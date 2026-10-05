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
