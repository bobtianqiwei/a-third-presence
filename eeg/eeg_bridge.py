# eeg_bridge.py developed by Bob Tianqi Wei
"""Two serial readers, quality gating, smoothing, and OSC output."""
import argparse
import glob
import math
import threading
import time
import sys
from pathlib import Path

if __package__ in (None, ''):
    sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from eeg.thinkgear import ThinkGearParser
import serial
from pythonosc.udp_client import SimpleUDPClient
from pythonosc.dispatcher import Dispatcher
from pythonosc.osc_server import OSCUDPServer

ATTENTION_SMOOTHING = 0.15
MEDITATION_SMOOTHING = 0.15
POSITION_SMOOTHING = 0.10
SIGNAL_THRESHOLD = 50
MIN_ATTENTION_SUM = 10
OSC_HOST = '127.0.0.1'
OSC_PORT = 9000
CONTROL_PORT = 9001
STALE_SECONDS = 3.0


class Participant:
    def __init__(self):
        self.lock = threading.Lock()
        self.values = dict(attention=50.0, meditation=50.0, signal=None,
                           alpha=0, beta=0, theta=0)
        self.connected = False
        self.last_signal = self.last_attention = 0.0
        self.valid_attention = False
        self.status = 'Waiting for receiver'

    def update(self, packet, now=None):
        now = time.monotonic() if now is None else now
        with self.lock:
            if 'signal' in packet:
                self.values['signal'] = packet['signal']
                self.last_signal = now
            good = (self.values['signal'] is not None and
                    self.values['signal'] <= SIGNAL_THRESHOLD and
                    now - self.last_signal <= STALE_SECONDS)
            for name, factor in [('attention', ATTENTION_SMOOTHING),
                                 ('meditation', MEDITATION_SMOOTHING)]:
                value = packet.get(name)
                if good and value is not None and 0 <= value <= 100:
                    self.values[name] += factor * (value - self.values[name])
                    if name == 'attention':
                        self.last_attention = now
                        self.valid_attention = True
            for name, lo, hi in [('alpha', 'low_alpha', 'high_alpha'),
                                 ('beta', 'low_beta', 'high_beta')]:
                if lo in packet and hi in packet:
                    self.values[name] = packet[lo] + packet[hi]
            if 'theta' in packet:
                self.values['theta'] = packet['theta']
            if 'raw' in packet:
                self.raw = packet['raw']

    def snapshot(self):
        with self.lock:
            values = dict(self.values)
            now = time.monotonic()
            usable = (self.connected and self.valid_attention and
                      now - self.last_attention <= STALE_SECONDS and
                      now - self.last_signal <= STALE_SECONDS and
                      values['signal'] is not None and values['signal'] <= SIGNAL_THRESHOLD)
            return values, usable, self.status


def scan_ports():
    return sorted(set(path for pattern in ('usbmodem*', 'usbserial*',
                      'SLAB_USBtoUART*', 'wchusbserial*')
                      for path in glob.glob('/dev/cu.' + pattern)))


def reader(port, participant, stop):
    while not stop.is_set():
        try:
            with serial.Serial(port, 57600, timeout=0.2) as device:
                parser = ThinkGearParser()
                with participant.lock:
                    participant.connected = True
                    participant.status = 'Connected'
                    participant.values['signal'] = None
                    participant.valid_attention = False
                while not stop.is_set():
                    for packet in parser.feed(device.read(256)):
                        participant.update(packet)
        except (serial.SerialException, OSError) as error:
            with participant.lock:
                participant.connected = False
                participant.status = 'Warning: disconnected or port busy; retrying: ' + str(error)
            stop.wait(2)
    with participant.lock:
        participant.connected = False


def next_position(previous, a, b, usable=True):
    total = a + b
    target = b / total if usable and total >= MIN_ATTENTION_SUM else 0.5
    return max(0.0, min(1.0, previous + POSITION_SMOOTHING * (target - previous)))


class ReceiverManager:
    """Own the two assignments and release old ports before starting new readers."""
    def __init__(self, simulated=False):
        self.simulated = simulated
        self.people = [Participant(), Participant()]
        self.ports = [None, None]
        self.available = []
        self.manual = [False, False]
        self.workers = [None, None]
        self.request_scan = True
        self.status = 'Run the EEG bridge, then select receivers in Max.'

    def _apply(self, desired):
        changed = [i for i in range(2) if desired[i] != self.ports[i] or
                   (self.workers[i] and self.workers[i][0].is_set())]
        for i in changed:
            if self.workers[i]:
                self.workers[i][0].set()
        for i in changed:
            if self.workers[i]:
                self.workers[i][1].join(timeout=1)
        if any(self.workers[i] and self.workers[i][1].is_alive() for i in changed):
            self.status = 'Receiver is still closing. Select again in a moment.'
            return False
        for i in changed:
            # Replacing the state prevents any late old-reader packet from leaking through.
            self.people[i] = Participant()
            self.ports[i] = desired[i]
            self.workers[i] = None
        for i in changed:
            if self.ports[i]:
                stop = threading.Event()
                thread = threading.Thread(target=reader,
                    args=(self.ports[i], self.people[i], stop), daemon=True)
                self.workers[i] = (stop, thread)
                thread.start()
        return True

    def update_available(self, ports):
        self.available = sorted(set(ports))
        # More than two candidates require an explicit menu selection.
        if self.simulated or len(self.available) > 2:
            return
        desired = self.ports.copy()
        for i in range(2):
            if desired[i] is None and not self.manual[i]:
                desired[i] = next((p for p in self.available if p not in desired), None)
        self._apply(desired)

    def select(self, index, port):
        if self.simulated:
            self.status = 'Simulation active. Restart without --simulate to select receivers.'
            return False
        port = None if port in ('', 'Not assigned') else port
        if port is not None and port not in self.available:
            self.status = 'Receiver unavailable. Click Refresh Receivers and try again.'
            return False
        desired = self.ports.copy()
        other = 1 - index
        swapped = port is not None and port == desired[other]
        if swapped:
            desired[other] = desired[index]
            self.manual[other] = True
        desired[index] = port
        self.manual[index] = True
        if not self._apply(desired):
            return False
        self.status = ('Participant A and B receivers swapped.' if swapped else
                       f'Participant {"AB"[index]} receiver ' + ('selected.' if port else 'unassigned.'))
        return True

    def close(self):
        for worker in self.workers:
            if worker:
                worker[0].set()
        for worker in self.workers:
            if worker:
                worker[1].join(timeout=1)


def create_control_server(manager, host=OSC_HOST, port=CONTROL_PORT):
    dispatcher = Dispatcher()

    def select(index, values):
        if len(values) != 1 or not isinstance(values[0], str):
            manager.status = 'Invalid receiver selection. Choose a receiver in Max.'
            return
        manager.select(index, values[0])

    for index, label in enumerate('ab'):
        dispatcher.map(f'/eeg/select/{label}',
                       lambda address, *values, index=index: select(index, values))
    dispatcher.map('/eeg/refresh', lambda address, *values: setattr(manager, 'request_scan', True))
    server = OSCUDPServer((host, port), dispatcher)
    server.timeout = 0
    return server


def send_device_status(client, snapshots, ports, simulated=False):
    for i, (label, (_, usable, status)) in enumerate(zip('ab', snapshots)):
        device = 'SIMULATED (no receiver)' if simulated else (
            ports[i] if i < len(ports) and ports[i] else 'Not assigned')
        client.send_message(f'/eeg/{label}/device', device)
        client.send_message(f'/eeg/{label}/status', status if not usable else status + ' / valid EEG')


def main():
    arg = argparse.ArgumentParser(description=__doc__)
    arg.add_argument('--simulate', action='store_true', help='Send clearly labeled synthetic EEG data.')
    args = arg.parse_args()
    manager = ReceiverManager(args.simulate)
    client = SimpleUDPClient(OSC_HOST, OSC_PORT)
    try:
        controls = create_control_server(manager)
    except OSError as error:
        print(f'Cannot listen for Max controls on {OSC_HOST}:{CONTROL_PORT}: {error}', file=sys.stderr)
        print('Close the other EEG bridge or free control port 9001, then restart.', file=sys.stderr)
        client.close()
        return 1
    if args.simulate:
        print('SIMULATION: synthetic data, no EEG hardware used.')
        manager.status = 'Simulation active. Restart without --simulate to select receivers.'
    else:
        ports = scan_ports()
        if not ports:
            print('No EEG receiver found. Plug in your USB receivers; scanning continues.')
        elif len(ports) == 1:
            print('Only one EEG receiver detected. Waiting for a second participant.')
        elif len(ports) > 2:
            print('More than two serial devices detected. Select Participant A and B receivers in Max.')
            for port in ports:
                print(port)
        manager.update_available(ports)
        manager.status = "Select a receiver from each menu. Selecting the other participant's receiver swaps assignments."
    position = 0.5
    last_display = last_scan = last_devices = 0
    stop = threading.Event()
    try:
        while True:
            now = time.monotonic()
            controls.handle_request()
            if args.simulate:
                for i, person in enumerate(manager.people):
                    person.connected = True
                    person.status = 'SIMULATED'
                    person.update(dict(signal=0, attention=50 + 35 * math.sin(now / 8 + i * math.pi), meditation=50))
            elif manager.request_scan or now - last_scan >= 2:
                last_scan = now
                manager.request_scan = False
                manager.update_available(scan_ports())
            snapshots = [person.snapshot() for person in manager.people]
            position = next_position(position, snapshots[0][0]['attention'],
                                     snapshots[1][0]['attention'], all(s[1] for s in snapshots))
            try:
                for label, (values, _, _) in zip('ab', snapshots):
                    for name, value in values.items():
                        if name in ('attention', 'meditation'):
                            value /= 100
                        client.send_message(f'/eeg/{label}/{name}', -1 if value is None else value)
                client.send_message('/sound/position', position)
                if now - last_devices >= 0.5:
                    send_device_status(client, snapshots, manager.ports, args.simulate)
                    client.send_message('/eeg/devices', manager.available)
                    client.send_message('/eeg/control/status', manager.status)
                    last_devices = now
            except OSError:
                pass
            if now - last_display >= 0.5:
                last_display = now
                lines = []
                for i, (label, (values, usable, status)) in enumerate(zip('AB', snapshots)):
                    device = 'SIMULATED (no receiver)' if args.simulate else (manager.ports[i] or 'Not assigned')
                    lines += [f'Participant {label}: {status}', f'Device: {device}',
                              f"Attention: {values['attention']/100:.2f}  Meditation: {values['meditation']/100:.2f}  Signal: {values['signal']}  Valid: {usable}"]
                lines += [f'Sound Position: {position:.2f}', f'OSC: {OSC_HOST}:{OSC_PORT}',
                          f'Max Controls: {OSC_HOST}:{CONTROL_PORT}', manager.status]
                print(('\033[2J\033[H' if sys.stdout.isatty() else '') + '\n'.join(lines), flush=True)
            stop.wait(0.05)
    except KeyboardInterrupt:
        print('\nStopping EEG bridge.')
    finally:
        controls.server_close()
        client.close()
        manager.close()
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
