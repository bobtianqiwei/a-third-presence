# test_automatic.py developed by Bob Tianqi Wei
import base64
import io
import json
from pathlib import Path
import tempfile
import threading
import unittest
from unittest.mock import MagicMock, patch

import numpy as np
import soundfile as sf

from flowedit.automatic import AutomaticSession, sound_prompt
from flowedit import controller


class SessionTests(unittest.TestCase):
    def setUp(self):
        self.now = 0.0
        self.start, self.generate, self.end = MagicMock(), MagicMock(return_value=True), MagicMock()
        self.session = AutomaticSession(self.start, self.generate, self.end, lambda: self.now)

    def advance(self, seconds, labels='ab', valid=True, a=0.8, m=0.7):
        for _ in range(round(seconds * 20)):
            self.now += 0.05
            for label in labels:
                self.session.sample('', label, valid, a, m)
            self.session.tick()

    def test_duo_capture_mapping_and_no_duplicate_job(self):
        self.advance(1.8)
        self.start.assert_not_called()
        self.advance(11)
        self.assertEqual(self.session.mode, 'Duo')
        self.generate.assert_called_once()
        means = self.generate.call_args.args[2]
        self.assertAlmostEqual(means['a'][0], 0.8)
        self.assertAlmostEqual(means['b'][1], 0.7)
        self.session.ready(0)
        self.advance(2)
        self.generate.assert_called_once()
        self.assertAlmostEqual(self.session.position, 0.5)

    def test_solo_b_full_range_and_absence_reset(self):
        self.advance(13, 'b', a=1)
        self.assertEqual(self.session.mode, 'Solo B')
        self.advance(4, 'b', a=1)
        self.assertGreater(self.session.position, 0.99)
        self.advance(4, 'b', a=0)
        self.assertLess(self.session.position, 0.01)
        self.advance(9, 'b', valid=False)
        self.assertEqual(self.session.phase, 'Waiting')
        self.end.assert_called_once_with(0)

    def test_receiver_without_good_contact_never_triggers(self):
        self.advance(30, valid=False)
        self.start.assert_not_called()
        self.generate.assert_not_called()
        self.session.sample('', 'a', 1, float('nan'), 0.5)
        self.assertFalse(self.session.status()['valid'][0])

    def test_stale_packets_and_brief_dropout(self):
        self.advance(13, 'a')
        self.advance(1, 'a', valid=False)
        self.advance(3, 'a')
        self.generate.assert_called_once()
        self.now += 4
        self.assertFalse(self.session.status()['valid'][0])

    def test_b_joins_during_capture_and_reset_invalidates_worker(self):
        self.advance(6, 'a')
        self.advance(7, 'ab')
        self.assertEqual(self.session.mode, 'Duo')
        self.session.reset()
        self.assertFalse(self.session.current(0))
        self.session.ready(0)
        self.assertEqual(self.session.phase, 'Waiting')

    def test_busy_service_retries_without_duplicate_generation(self):
        self.generate.return_value = False
        self.advance(13, 'a')
        self.assertEqual(self.session.phase, 'Pending')
        self.generate.return_value = True
        self.advance(1, 'a')
        calls = self.generate.call_count
        self.advance(2, 'a')
        self.assertEqual(self.generate.call_count, calls)

    def test_four_prompt_rules(self):
        self.assertIn('clear, rhythmic', sound_prompt(0.9, 0.9))
        self.assertIn('soft, smooth', sound_prompt(0.9, 0.9))
        self.assertIn('diffuse, scattered', sound_prompt(0.1, 0.1))
        self.assertIn('rough, unstable', sound_prompt(0.1, 0.1))

    def test_next_person_on_other_receiver_ends_previous_solo(self):
        self.advance(13, 'a')
        self.advance(13, 'b')
        self.assertEqual(self.session.epoch, 1)
        self.assertEqual(self.session.phase, 'Collecting')


class GenerationTests(unittest.TestCase):
    def wav(self, amplitude):
        buffer = io.BytesIO()
        sf.write(buffer, np.full(24000, amplitude, dtype=float), 24000, format='WAV', subtype='PCM_16')
        return buffer.getvalue()

    def test_duo_then_inherited_solo_preserves_all_intermediates(self):
        seed, a, b, solo = (self.wav(v) for v in (0, 0.1, 0.2, 0.3))
        def result(data):
            encoded = base64.b64encode(data).decode()
            return dict(seed=1, final=dict(audio_b64=encoded),
                        intermediates=[dict(label=f't={i/10}', audio_b64=encoded) for i in range(1, 10)])
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            (root / 'audio/default').mkdir(parents=True)
            (root / 'audio/default/seed.wav').write_bytes(seed)
            with patch.object(controller, 'ROOT', root), patch.object(controller, 'load_key', return_value='test'), \
                    patch.object(controller, 'SimpleUDPClient'):
                app = controller.Controller()
                app.wait_present = MagicMock(return_value=True)
                app.generate_sound = MagicMock(side_effect=[(result(a), {}), (result(b), {}), (result(solo), {})])
                app.lock.acquire()
                app.run_automatic(0, 'Duo', {'a': (0.8, 0.7), 'b': (0.2, 0.3)})
                self.assertEqual(app.generate_sound.call_args_list[1].args[1], a)
                folders = sorted((root / 'audio/sessions').glob('*/stage_*'))
                self.assertEqual(len(folders), 2)
                self.assertTrue(all(len(list(folder.glob('*.wav'))) == 11 for folder in folders))
                app.reset()
                saved = json.loads((root / 'audio/history.json').read_text())
                self.assertEqual(Path(saved['path']).read_bytes(), b)
                app.lock.acquire()
                app.run_automatic(1, 'Solo A', {'a': (0.5, 0.5)})
                self.assertEqual(app.generate_sound.call_args.args[1], b)
                app.reset()
                saved = json.loads((root / 'audio/history.json').read_text())
                self.assertEqual(Path(saved['path']).read_bytes(), solo)

    def test_reset_during_request_does_not_publish_old_result(self):
        with patch.object(controller, 'load_key', return_value='test'), patch.object(controller, 'SimpleUDPClient'):
            app = controller.Controller()
            app.wait_present = MagicMock(return_value=True)
            def generate(*_):
                app.reset()
                return {}, {}
            app.generate_sound = generate
            app.lock.acquire()
            app.run_automatic(0, 'Duo', {'a': (0.8, 0.7), 'b': (0.2, 0.3)})
            self.assertIsNone(app.inherited)
            self.assertFalse(app.lock.locked())

    def test_generation_uses_documented_api_body(self):
        audio = self.wav(0.1)
        with patch.object(controller, 'SimpleUDPClient'), patch.object(controller, 'request', return_value=({}, {})) as request:
            app = controller.Controller()
            session = MagicMock()
            app.generate_sound(session, audio, 'source sound', 'target sound')
            body = request.call_args.args[2]
            self.assertEqual(request.call_args.args[1], '/generate')
            self.assertEqual(base64.b64decode(body['audio_b64']), audio)
            self.assertEqual(body['src_prompt'], 'source sound')
            self.assertEqual(body['tar_prompt'], 'target sound')
            self.assertEqual(body['num_intermediates'], 9)
            self.assertEqual(body['seconds_total'], 1)

    def test_background_request_does_not_block_eeg_or_reset(self):
        entered, release = threading.Event(), threading.Event()
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            (root / 'audio/default').mkdir(parents=True)
            (root / 'audio/default/seed.wav').write_bytes(self.wav(0.1))
            with patch.object(controller, 'ROOT', root), patch.object(controller, 'load_key', return_value='test'), \
                    patch.object(controller, 'SimpleUDPClient'):
                app = controller.Controller()
                app.auto.sample('', 'a', 1, 0.8, 0.6)
                def blocking_request(*_):
                    entered.set()
                    release.wait(3)
                    return {}, {}
                app.generate_sound = blocking_request
                app.auto_generate(0, 'Solo A', {'a': (0.8, 0.6)})
                try:
                    self.assertTrue(entered.wait(2))
                    app.auto.sample('', 'a', 1, 0.9, 0.7)
                    self.assertEqual(app.auto.people['a']['attention'], 0.9)
                    app.reset()
                    self.assertEqual(app.auto.epoch, 1)
                finally:
                    release.set()
                    app.worker.join(2)
                self.assertFalse(app.worker.is_alive())
                self.assertFalse(app.lock.locked())

    def test_max_reconnect_gets_current_automatic_sound(self):
        with patch.object(controller, 'SimpleUDPClient') as client:
            app = controller.Controller()
            app.bridge = MagicMock()
            app.bridge.poll.return_value = None
            app.send('play', '/automatic/sequence')
            client.return_value.send_message.reset_mock()
            app.start_eeg()
            client.return_value.send_message.assert_called_once_with('/session/play', '/automatic/sequence')


if __name__ == '__main__':
    unittest.main()
