import unittest

from prudentia.utils.bash import BashCmd


class TestBash(unittest.TestCase):
    def test_success_echo(self):
        echoed_string = 'yo'
        cmd = BashCmd("echo", echoed_string)
        cmd.execute()
        self.assertTrue(cmd.is_ok())
        self.assertEqual(cmd.output(), echoed_string + '\n')

    def test_nonexistent_cmd(self):
        cmd = BashCmd("ciwawa")
        cmd.execute()
        self.assertFalse(cmd.is_ok())
