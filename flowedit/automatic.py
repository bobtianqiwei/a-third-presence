# automatic.py developed by Bob Tianqi Wei
"""Automatic sessions; EEG sound rules are artistic mappings, not emotion inference."""
import math
import threading
import time

STABLE_SECONDS = 2.0
CAPTURE_SECONDS = 10.0
STALE_SECONDS = 3.0
DEPARTURE_SECONDS = 8.0
MIN_CAPTURE_SECONDS = 2.0
PROMPT_THRESHOLD = 0.5


def sound_prompt(attention, meditation):
    structure = ('clear, rhythmic sounds with a steady pulse and a defined structure'
                 if attention >= PROMPT_THRESHOLD else
                 'diffuse, scattered, abstract sounds with an indistinct structure')
    texture = ('soft, smooth, sustained tones' if meditation >= PROMPT_THRESHOLD else
               'rough, unstable textures with restless movement')
    return f'An instrumental soundscape with {structure} and {texture}. No speech.'


class AutomaticSession:
    def __init__(self, start, generate, end, clock=time.monotonic):
        self.clock, self.start, self.generate, self.end = clock, start, generate, end
        self.lock = threading.RLock()
        self.people = {label: dict(valid=False, seen=-math.inf, since=None,
                                  attention=0.5, meditation=0.5) for label in 'ab'}
        self.epoch = 0
        self.phase, self.mode = 'Waiting', 'Waiting'
        self.began = self.absent = None
        self.samples = {label: [] for label in 'ab'}
        self.next_sample = 0
        self.position = 0.5
        self.means = {}

    def sample(self, _, label, valid, attention, meditation):
        if label not in self.people:
            return
        try:
            a, m = float(attention), float(meditation)
            usable = bool(int(valid)) and all(math.isfinite(v) and 0 <= v <= 1 for v in (a, m))
        except (ValueError, TypeError, OverflowError):
            return
        with self.lock:
            now = self.clock()
            person = self.people[label]
            was_valid = person['valid'] and now - person['seen'] <= STALE_SECONDS
            person.update(valid=usable, seen=now, attention=a, meditation=m)
            if not usable:
                person['since'] = None
            elif not was_valid:
                person['since'] = now

    def valid(self, label, now):
        p = self.people[label]
        return p['valid'] and now - p['seen'] <= STALE_SECONDS

    def stable(self, label, now):
        p = self.people[label]
        return self.valid(label, now) and p['since'] is not None and now - p['since'] >= STABLE_SECONDS

    def current(self, epoch):
        with self.lock:
            return epoch == self.epoch

    def present(self, epoch):
        with self.lock:
            now = self.clock()
            return epoch == self.epoch and any(self.valid(label, now) for label in (self.means or self.people))

    def reset(self, *_):
        with self.lock:
            self.end(self.epoch)
            self.epoch += 1
            self.phase, self.mode = 'Waiting', 'Waiting'
            self.began = self.absent = None
            self.means = {}
            self.samples = {label: [] for label in 'ab'}
            for person in self.people.values():
                person['since'] = self.clock() if person['valid'] else None

    def tick(self):
        with self.lock:
            now = self.clock()
            valid = {label: self.valid(label, now) for label in 'ab'}
            for label in 'ab':
                if not valid[label]:
                    self.people[label]['since'] = None
            if not any(valid[label] for label in (self.means or self.people)):
                if self.absent is None:
                    self.absent = now
                if self.phase != 'Waiting' and now - self.absent >= DEPARTURE_SECONDS:
                    self.reset()
                return
            self.absent = None
            if self.phase == 'Waiting' and any(self.stable(label, now) for label in 'ab'):
                self.phase, self.mode, self.began = 'Collecting', 'Collecting', now
                self.next_sample = now
                self.start(self.epoch)
            if self.phase == 'Collecting':
                if now >= self.next_sample:
                    for label in 'ab':
                        if valid[label]:
                            p = self.people[label]
                            self.samples[label].append((p['attention'], p['meditation']))
                    self.next_sample = now + 0.1
                if now - self.began < CAPTURE_SECONDS:
                    return
                eligible = [label for label in 'ab' if self.stable(label, now) and
                            len(self.samples[label]) >= MIN_CAPTURE_SECONDS * 10]
                if not eligible:
                    self.reset()
                    return
                self.means = {label: tuple(sum(row[i] for row in self.samples[label]) /
                                          len(self.samples[label]) for i in (0, 1)) for label in eligible}
                self.mode = 'Duo' if len(eligible) == 2 else 'Solo ' + eligible[0].upper()
                self.phase = 'Pending'
            if self.phase == 'Pending' and self.generate(self.epoch, self.mode, dict(self.means)):
                self.phase = 'Generating'
            if self.phase in ('Generating', 'Ready', 'Pending'):
                if self.mode == 'Duo':
                    a = self.people['a']['attention'] if valid['a'] else 0
                    b = self.people['b']['attention'] if valid['b'] else 0
                    target = b / (a + b) if a + b > 0 else self.position
                else:
                    label = 'a' if self.mode == 'Solo A' else 'b'
                    target = self.people[label]['attention'] if valid[label] else self.position
                self.position += 0.08 * (target - self.position)

    def ready(self, epoch):
        with self.lock:
            if epoch == self.epoch:
                self.phase = 'Ready'

    def status(self):
        with self.lock:
            now = self.clock()
            remaining = max(0, math.ceil(CAPTURE_SECONDS - (now - self.began))) if self.phase == 'Collecting' else 0
            return dict(mode=self.mode, phase=self.phase, countdown=remaining,
                        position=self.position, valid=[self.valid(label, now) for label in 'ab'])
