# test_core.py developed by Bob Tianqi Wei
import base64
import io
import json
from pathlib import Path
import tempfile
import threading
import time
import unittest
from unittest.mock import patch
import socket
import pty
import os

import numpy as np
import soundfile as sf
from pythonosc.osc_message import OscMessage
from pythonosc.udp_client import SimpleUDPClient
from eeg.thinkgear import ThinkGearParser, BANDS
from eeg.eeg_bridge import Participant, next_position, reader, send_device_status, ReceiverManager, create_control_server
from flowedit.prepare_audio import save_sequence, describe, request, NUM_INTERMEDIATES


def frame(payload):
    return b'\xaa\xaa' + bytes([len(payload)]) + payload + bytes([~sum(payload) & 255])


def wav():
    stream = io.BytesIO()
    sf.write(stream, np.zeros(1000), 1000, format='WAV', subtype='PCM_16')
    return stream.getvalue()


class ParserTests(unittest.TestCase):
    def test_example_and_fragmentation(self):
        p = ThinkGearParser()
        output = []
        for byte in bytes.fromhex('AA AA 04 80 02 FF 4B 33'):
            output += p.feed(bytes([byte]))
        self.assertEqual(output, [{'raw': -181}])

    def test_all_codes_and_power(self):
        powers = b''.join(i.to_bytes(3, 'big') for i in range(1, 9))
        payload = bytes([2, 0, 4, 80, 5, 60, 0x16, 42, 0x83, 24]) + powers
        result = ThinkGearParser().feed(frame(payload))[0]
        self.assertEqual([result[b] for b in BANDS], list(range(1, 9)))
        self.assertEqual(result['attention'], 80)
        self.assertEqual(result['meditation'], 60)
        self.assertEqual(result['blink'], 42)
        self.assertEqual(result['signal'], 0)

    def test_resync_checksum_malformed_extended(self):
        p = ThinkGearParser()
        bad = bytearray(frame(bytes([4, 10])))
        bad[-1] ^= 1
        data = b'noise\xaa\xaa\xaa' + bad + frame(b'\x83\x18\x01') + frame(b'\x55\x04\x64\x04\x32')
        self.assertEqual(p.feed(data), [{'attention': 50}])
        self.assertGreater(p.checksum_errors, 0)
        self.assertEqual(p.malformed_packets, 1)

    def test_many_packets_and_unknown(self):
        p = ThinkGearParser()
        self.assertEqual(p.feed(frame(b'\x7f\x01\x90\x02\x00\x00\x04\x20') * 100), [{'attention': 32}] * 100)
        self.assertLess(len(p.buffer), 4)


class BridgeTests(unittest.TestCase):
    def test_mapping_neutral_and_bounds(self):
        self.assertAlmostEqual(next_position(.5, 80, 20), .47)
        self.assertAlmostEqual(next_position(.5, 20, 80), .53)
        self.assertEqual(next_position(.5, 50, 50), .5)
        self.assertEqual(next_position(.5, 0, 0), .5)
        self.assertAlmostEqual(next_position(0, 80, 20, False), .05)
        for _ in range(1000):
            self.assertTrue(0 <= next_position(.5, 0, 100) <= 1)

    def test_gating_smoothing_and_staleness(self):
        p = Participant()
        p.connected = True
        p.update({'attention': 100})
        self.assertEqual(p.values['attention'], 50)
        p.update({'signal': 0, 'attention': 100, 'meditation': 0,
                  'low_alpha': 2, 'high_alpha': 3, 'low_beta': 4, 'high_beta': 5})
        self.assertEqual(p.values['attention'], 57.5)
        self.assertEqual(p.values['alpha'], 5)
        self.assertEqual(p.values['beta'], 9)
        self.assertTrue(p.snapshot()[1])
        p.update({'signal': 200, 'attention': 100})
        self.assertEqual(p.values['attention'], 57.5)
        self.assertFalse(p.snapshot()[1])
        p.update({'signal': 0, 'attention': 255})
        self.assertEqual(p.values['attention'], 57.5)
        p.last_signal = 0
        p.update({'attention': 100})
        self.assertEqual(p.values['attention'], 57.5)

    def test_two_serial_readers_and_disconnect(self):
        pairs = [pty.openpty(), pty.openpty()]
        people = [Participant(), Participant()]
        stop = threading.Event()
        threads = []
        try:
            for (_, slave), person in zip(pairs, people):
                t = threading.Thread(target=reader, args=(os.ttyname(slave), person, stop), daemon=True)
                threads.append(t); t.start()
            deadline = time.monotonic() + 3
            while not all(p.connected for p in people) and time.monotonic() < deadline:
                time.sleep(.01)
            self.assertTrue(all(p.connected for p in people))
            # A times out; B must still receive its packet.
            os.write(pairs[1][0], frame(bytes([2, 0, 4, 80])))
            deadline = time.monotonic() + 2
            while not people[1].valid_attention and time.monotonic() < deadline:
                time.sleep(.01)
            self.assertTrue(people[1].valid_attention)
            os.close(pairs[0][0]); pairs[0] = (-1, pairs[0][1])
            os.write(pairs[1][0], frame(bytes([2, 0, 4, 90])))
            time.sleep(.4)
            self.assertGreater(people[1].values['attention'], 54.5)
        finally:
            stop.set()
            for t in threads: t.join(1)
            for master, slave in pairs:
                if master >= 0: os.close(master)
                os.close(slave)

    def test_real_serial_swap_via_osc(self):
        pairs = [pty.openpty(), pty.openpty()]
        masters = {os.ttyname(slave): master for master, slave in pairs}
        manager = ReceiverManager()
        server = create_control_server(manager, port=0)
        client = SimpleUDPClient('127.0.0.1', server.server_address[1])

        def wait_for(predicate):
            deadline = time.monotonic() + 3
            while not predicate() and time.monotonic() < deadline:
                time.sleep(.01)
            self.assertTrue(predicate())

        try:
            manager.update_available(list(masters))
            wait_for(lambda: all(p.connected for p in manager.people))
            old_ports = manager.ports.copy()
            old_workers = manager.workers.copy()
            client.send_message('/eeg/select/a', old_ports[1])
            deadline = time.monotonic() + 3
            while manager.ports[0] != old_ports[1] and time.monotonic() < deadline:
                server.handle_request()
            self.assertEqual(manager.ports, list(reversed(old_ports)))
            self.assertTrue(all(not w[1].is_alive() for w in old_workers))
            wait_for(lambda: all(p.connected for p in manager.people))
            self.assertFalse(any(p.valid_attention for p in manager.people))
            os.write(masters[manager.ports[0]], frame(bytes([2, 0, 4, 80])))
            os.write(masters[manager.ports[1]], frame(bytes([2, 0, 4, 20])))
            wait_for(lambda: all(p.valid_attention for p in manager.people))
            self.assertEqual(manager.people[0].values['attention'], 54.5)
            self.assertEqual(manager.people[1].values['attention'], 45.5)
        finally:
            server.server_close()
            client.close()
            manager.close()
            for master, slave in pairs:
                os.close(master)
                os.close(slave)

    def test_device_labels_and_selection(self):
        from unittest.mock import Mock
        client = Mock()
        snapshots = [(dict(), True, 'Connected'), (dict(), False, 'Waiting for receiver')]
        send_device_status(client, snapshots, ['/dev/cu.usbmodemA'])
        messages = dict(call.args for call in client.send_message.call_args_list)
        self.assertEqual(messages['/eeg/a/device'], '/dev/cu.usbmodemA')
        self.assertEqual(messages['/eeg/b/device'], 'Not assigned')
        self.assertEqual(messages['/eeg/a/status'], 'Connected / valid EEG')
        client.reset_mock()
        send_device_status(client, snapshots, [], simulated=True)
        messages = dict(call.args for call in client.send_message.call_args_list)
        self.assertEqual(messages['/eeg/a/device'], 'SIMULATED (no receiver)')
        self.assertEqual(messages['/eeg/b/device'], 'SIMULATED (no receiver)')

    def test_real_osc_udp(self):
        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as receiver:
            receiver.bind(('127.0.0.1', 0)); receiver.settimeout(1)
            client = SimpleUDPClient('127.0.0.1', receiver.getsockname()[1])
            client.send_message('/sound/position', .63)
            client.close()
            msg = OscMessage(receiver.recv(1024))
            self.assertEqual(msg.address, '/sound/position')
            self.assertAlmostEqual(msg.params[0], .63, places=6)


class ReceiverSelectionTests(unittest.TestCase):
    def setUp(self):
        def fake_reader(port, person, stop):
            person.connected = True
            person.status = 'Connected'
            stop.wait()
            person.connected = False
        self.reader_patch = patch('eeg.eeg_bridge.reader', side_effect=fake_reader)
        self.reader_patch.start()
        self.manager = ReceiverManager()

    def tearDown(self):
        self.manager.close()
        self.reader_patch.stop()

    def test_auto_assignment_and_unassign(self):
        self.manager.update_available(['portB', 'portA'])
        self.assertEqual(self.manager.ports, ['portA', 'portB'])
        self.assertTrue(self.manager.select(0, 'Not assigned'))
        self.manager.update_available(['portA', 'portB'])
        self.assertEqual(self.manager.ports, [None, 'portB'])
        self.assertTrue(self.manager.select(0, 'portA'))

    def test_more_than_two_waits_for_menu_selection(self):
        self.manager.update_available(['portA', 'portB', 'portC'])
        self.assertEqual(self.manager.ports, [None, None])
        self.assertTrue(self.manager.select(1, 'portC'))
        self.assertEqual(self.manager.ports, [None, 'portC'])

    def test_swap_releases_readers_and_resets_old_data(self):
        self.manager.update_available(['portA', 'portB'])
        old_workers = self.manager.workers.copy()
        self.manager.people[0].update({'signal': 0, 'attention': 90})
        old_a = self.manager.people[0]
        self.assertTrue(self.manager.select(0, 'portB'))
        self.assertEqual(self.manager.ports, ['portB', 'portA'])
        self.assertTrue(all(not w[1].is_alive() for w in old_workers))
        self.assertIsNot(self.manager.people[0], old_a)
        self.assertFalse(self.manager.people[0].valid_attention)
        self.assertEqual(self.manager.people[0].values['attention'], 50)
        same = self.manager.people[0]
        self.assertTrue(self.manager.select(0, 'portB'))
        self.assertIs(self.manager.people[0], same)

    def test_invalid_selection_and_unchanged_participant(self):
        self.manager.update_available(['portA', 'portB'])
        self.manager.update_available(['portA', 'portB', 'portC'])
        b_worker = self.manager.workers[1]
        self.assertFalse(self.manager.select(0, 'unknown'))
        self.assertEqual(self.manager.ports, ['portA', 'portB'])
        self.assertTrue(self.manager.select(0, 'portC'))
        self.assertIs(self.manager.workers[1], b_worker)
        self.manager.update_available(['portA', 'portB'])
        self.assertEqual(self.manager.ports, ['portC', 'portB'])

    def test_real_osc_selection_and_refresh(self):
        self.manager.update_available(['portA', 'portB', 'portC'])
        server = create_control_server(self.manager, port=0)
        client = SimpleUDPClient('127.0.0.1', server.server_address[1])
        try:
            client.send_message('/eeg/select/a', 'portB')
            deadline = time.monotonic() + 1
            while self.manager.ports[0] != 'portB' and time.monotonic() < deadline:
                server.handle_request()
            self.assertEqual(self.manager.ports, ['portB', None])
            client.send_message('/eeg/select/b', 'portB')
            deadline = time.monotonic() + 1
            while self.manager.ports[1] != 'portB' and time.monotonic() < deadline:
                server.handle_request()
            self.assertEqual(self.manager.ports, [None, 'portB'])
            self.manager.request_scan = False
            client.send_message('/eeg/refresh', 1)
            deadline = time.monotonic() + 1
            while not self.manager.request_scan and time.monotonic() < deadline:
                server.handle_request()
            self.assertTrue(self.manager.request_scan)
            client.send_message('/eeg/select/b', 123)
            deadline = time.monotonic() + 1
            while 'Invalid' not in self.manager.status and time.monotonic() < deadline:
                server.handle_request()
            self.assertIn('Invalid', self.manager.status)
            self.assertEqual(self.manager.ports, [None, 'portB'])
        finally:
            server.server_close()
            client.close()

    def test_simulation_does_not_open_hardware(self):
        manager = ReceiverManager(simulated=True)
        manager.update_available(['portA'])
        self.assertFalse(manager.select(0, 'portA'))
        self.assertEqual(manager.ports, [None, None])


class FlowTests(unittest.TestCase):
    def test_notebook_request_format(self):
        from unittest.mock import Mock
        session = Mock()
        response = session.post.return_value
        response.ok = True
        response.json.return_value = {'caption': 'A steady voice.'}
        data = wav()
        self.assertEqual(describe(session, data), 'A steady voice.')
        args, kwargs = session.post.call_args
        self.assertTrue(args[0].endswith('/describe'))
        self.assertEqual(base64.b64decode(kwargs['json']['audio_b64']), data)
        self.assertEqual(kwargs['json']['words'], 40)
        self.assertEqual(kwargs['timeout'], (30, 120))
        response.ok = False; response.status_code = 401
        with self.assertRaises(RuntimeError): request(session, '/generate', {}, 2700)

    def test_order_endpoints_metadata_and_preservation(self):
        data = wav(); encoded = base64.b64encode(data).decode()
        result = dict(seed=123, intermediates=[dict(label=f't={i/10}', audio_b64=encoded)
                       for i in range(1, NUM_INTERMEDIATES+1)], final=dict(audio_b64=encoded))
        with tempfile.TemporaryDirectory() as temp:
            out = Path(temp) / 'generated'
            metadata = save_sequence(data, data, result, ['A', 'B'], out, {})
            self.assertEqual(len(metadata['files']), 12)
            self.assertEqual(metadata['intermediate_labels'][0], 't=0.9')
            self.assertEqual((out/'00_A.wav').read_bytes(), data)
            self.assertEqual((out/'11_B.wav').read_bytes(), data)
            self.assertEqual(json.loads((out/'metadata.json').read_text())['seed'], 123)
            result['final']['audio_b64'] = base64.b64encode(b'bad').decode()
            with self.assertRaises(Exception): save_sequence(data, data, result, ['A', 'B'], out, {})
            self.assertEqual((out/'00_A.wav').read_bytes(), data)

    def test_complete_preparation_with_mocked_service(self):
        from unittest.mock import MagicMock
        from contextlib import redirect_stdout
        from flowedit import prepare_audio
        data = wav()
        encoded = base64.b64encode(data).decode()
        response = dict(seed=8, intermediates=[dict(label=f't={i/10}', audio_b64=encoded)
                        for i in range(1, 10)], final=dict(audio_b64=encoded))
        session = MagicMock()
        session.headers = {}
        session.__enter__.return_value = session
        replies = []
        for content in ({'caption': 'Voice A'}, {'caption': 'Voice B'}, response):
            reply = MagicMock()
            reply.ok = True
            reply.json.return_value = content
            reply.headers = {}
            replies.append(reply)
        session.post.side_effect = replies
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            (root/'audio/input').mkdir(parents=True)
            for label in 'AB': (root/'audio/input'/f'{label}.wav').write_bytes(data)
            with patch.object(prepare_audio, 'ROOT', root), \
                 patch.object(prepare_audio.requests, 'Session', return_value=session), \
                 patch.dict(os.environ, {'FLOWEDIT_KEY': 'test-key'}), \
                 redirect_stdout(io.StringIO()):
                self.assertEqual(prepare_audio.main(), 0)
            self.assertEqual(session.headers['Authorization'], 'Bearer test-key')
            calls = session.post.call_args_list
            self.assertEqual(len(calls), 3)
            self.assertTrue(calls[-1].args[0].endswith('/generate'))
            body = calls[-1].kwargs['json']
            self.assertEqual(body['src_prompt'], 'Voice A')
            self.assertEqual(body['tar_prompt'], 'Voice B')
            self.assertEqual(body['seconds_total'], 1)
            self.assertEqual(body['num_intermediates'], 9)
            self.assertEqual(body['lfe_steps'], 20)
            self.assertEqual(body['n_avg'], 10)
            self.assertEqual(body['seed'], -1)
            self.assertTrue(body['even_steps'])
            self.assertEqual(calls[-1].kwargs['timeout'], (30, 2700))
            self.assertEqual((root/'audio/generated/11_B.wav').read_bytes(), data)

    def test_patch_json_cords_and_osc(self):
        patch = json.loads((Path(__file__).resolve().parents[1]/'max/performance.maxpat').read_text())['patcher']
        boxes = {b['box']['id']: b['box'] for b in patch['boxes']}
        self.assertEqual(boxes['udp']['text'], 'udpreceive 9000')
        self.assertIn('/sound/position', boxes['oscroute']['text'])
        self.assertEqual(len(boxes), len(patch['boxes']))
        for line in patch['lines']:
            self.assertIn(line['patchline']['source'][0], boxes)
            self.assertIn(line['patchline']['destination'][0], boxes)
        self.assertEqual(boxes['dsp']['maxclass'], 'ezdac~')
        self.assertEqual(boxes['shared_clock']['text'], 'phasor~ 0.')
        self.assertEqual(boxes['shared_time']['varname'], 'shared_time')
        self.assertNotIn('playerA', boxes)
        self.assertIn('/eeg/a/device', boxes['oscroute']['text'])
        self.assertIn('/eeg/b/status', boxes['oscroute']['text'])
        self.assertEqual(boxes['recorder_a']['text'], 'sfrecord~ 1')
        self.assertEqual(boxes['recorder_b']['text'], 'sfrecord~ 1')
        self.assertEqual(boxes['mic']['text'], 'adc~ 1')
        self.assertEqual(boxes['prompt']['maxclass'], 'comment')
        cords = [(line['patchline']['source'], line['patchline']['destination']) for line in patch['lines']]
        self.assertIn((['mic', 0], ['recorder_a', 0]), cords)
        self.assertIn((['session', 1], ['recorder_b', 0]), cords)
        self.assertIn((['oscroute', 7], ['set_device_a', 0]), cords)
        self.assertEqual(boxes['receiver_menu_a']['maxclass'], 'umenu')
        self.assertEqual(boxes['receiver_menu_b']['menumode'], 0)
        self.assertEqual(boxes['control_send']['text'], 'udpsend 127.0.0.1 9001')
        self.assertIn((['receiver_menu_a', 0], ['receiver_choice_a', 0]), cords)
        self.assertIn((['receivers', 2], ['control_send', 0]), cords)
        self.assertIn((['oscroute', 11], ['device_list_pre', 0]), cords)


if __name__ == '__main__':
    unittest.main()
