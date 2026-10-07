# test_controller.py developed by Bob Tianqi Wei
import hashlib
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import MagicMock, patch

from flowedit import controller


class ControllerTests(unittest.TestCase):
    def test_changed_b_is_described_and_generation_uses_its_prompt(self):
        with tempfile.TemporaryDirectory() as temp:
            cache = Path(temp) / 'prompt.json'
            cache.write_text(json.dumps({'sha256': 'old', 'caption': 'old prompt'}))
            client = MagicMock()
            with patch.object(controller, 'SimpleUDPClient', return_value=client), \
                    patch.object(controller, 'CACHE', cache), \
                    patch.object(controller, 'load_key', return_value='test-key'), \
                    patch.object(controller, 'read_audio', side_effect=[(b'new B', None), (b'A', MagicMock(duration=3))]), \
                    patch.object(controller, 'describe', side_effect=['new B prompt', 'A prompt']) as describe, \
                    patch.object(controller, 'request', return_value=({}, {})) as request, \
                    patch.object(controller, 'save_sequence') as save:
                app = controller.Controller()
                app.lock.acquire()
                app.run(True)
                self.assertEqual(describe.call_count, 2)
                self.assertEqual(request.call_args.args[2]['tar_prompt'], 'new B prompt')
                self.assertEqual(json.loads(cache.read_text())['sha256'], hashlib.sha256(b'new B').hexdigest())
                save.assert_called_once()
                client.send_message.assert_any_call('/session/complete', 1)
                self.assertFalse(app.lock.locked())

    def test_edited_prompts_are_sent_exactly_without_describing_again(self):
        prompts = ('A "soft voice"\nwith pauses', 'B voice, warmer and slower')
        with patch.object(controller, 'SimpleUDPClient'), \
                patch.object(controller, 'load_key', return_value='test-key'), \
                patch.object(controller, 'read_audio', side_effect=[(b'B', None), (b'A', MagicMock(duration=3))]), \
                patch.object(controller, 'describe') as describe, \
                patch.object(controller, 'request', return_value=({}, {})) as request, \
                patch.object(controller, 'save_sequence') as save:
            app = controller.Controller()
            app.lock.acquire()
            app.run(True, prompts)
            describe.assert_not_called()
            self.assertEqual(request.call_args.args[2]['src_prompt'], prompts[0])
            self.assertEqual(request.call_args.args[2]['tar_prompt'], prompts[1])
            self.assertEqual(save.call_args.args[3], list(prompts))
            self.assertFalse(app.lock.locked())

    def test_a_preview_requires_only_a_recording_and_preserves_b_cache(self):
        with tempfile.TemporaryDirectory() as temp:
            cache = Path(temp) / 'prompt.json'
            cache.write_text(json.dumps({'sha256': 'B hash', 'caption': 'B caption'}))
            client = MagicMock()
            with patch.object(controller, 'SimpleUDPClient', return_value=client), \
                    patch.object(controller, 'CACHE', cache), \
                    patch.object(controller, 'load_key', return_value='test-key'), \
                    patch.object(controller, 'read_audio', return_value=(b'A', None)) as read, \
                    patch.object(controller, 'describe', return_value='A caption'), \
                    patch.object(controller, 'request') as request:
                app = controller.Controller()
                app.lock.acquire()
                app.run(False, label='A')
                read.assert_called_once_with('A')
                request.assert_not_called()
                client.send_message.assert_any_call('/session/prompt_a', 'A caption')
                self.assertEqual(json.loads(cache.read_text())['caption'], 'B caption')
                self.assertEqual(json.loads(cache.read_text())['a']['caption'], 'A caption')

    def test_missing_recording_is_shown_and_job_released(self):
        with patch.object(controller, 'SimpleUDPClient'), \
                patch.object(controller, 'read_audio', side_effect=ValueError('Record B first.')):
            app = controller.Controller()
            app.lock.acquire()
            app.run(False)
            self.assertEqual(app.status, 'Error: Record B first.')
            self.assertFalse(app.lock.locked())


if __name__ == '__main__':
    unittest.main()
