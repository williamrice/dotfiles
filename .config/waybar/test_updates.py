import json
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

import updates


class UpdateStatusTests(unittest.TestCase):
    row = "example 1.0-1 -> 2.0-1"

    def test_gear_and_drawer_share_count_state(self):
        for count in (0, 1, 12):
            with self.subTest(count=count):
                state = {"updates": [self.row] * count, "checked_at": 100}
                gear = updates.render("gear", state)
                drawer = updates.render("count", state)
                self.assertEqual(gear["class"], drawer["class"])
                self.assertEqual("updates" in gear["class"], count > 0)
                self.assertEqual(drawer["text"], str(count))

    def test_initial_failure_is_unknown_instead_of_zero(self):
        state = {"error": "offline"}
        self.assertEqual(updates.render("count", state)["text"], "?")
        self.assertIn("error", updates.render("gear", state)["class"])

    def test_shared_cache_and_failed_refresh_preserve_last_result(self):
        installed = subprocess.CompletedProcess([], 0, "example 1.0-1\n", "")
        with tempfile.TemporaryDirectory() as directory:
            runtime = Path(directory)
            with patch.object(updates, "check_updates", return_value=[self.row]) as check:
                with patch.object(updates.subprocess, "run", return_value=installed):
                    first = updates.load_status(runtime)
                    second = updates.load_status(runtime)
                self.assertEqual(check.call_count, 1)
                self.assertEqual(first["updates"], second["updates"])
            with patch.object(updates, "check_updates", side_effect=RuntimeError("offline")):
                with patch.object(updates.subprocess, "run", return_value=installed):
                    stale = updates.load_status(runtime, force=True)
            self.assertEqual(updates.render("count", stale)["text"], "1")
            self.assertEqual(updates.render("gear", stale)["class"], ["updates", "stale"])
            self.assertEqual(json.loads((runtime / "waybar-updates.json").read_text())["error"], "offline")

    def test_installed_and_removed_packages_clear_cached_updates(self):
        self.assertEqual(updates.pending_updates([self.row], {"example": "1.0-1"}), [self.row])
        self.assertEqual(updates.pending_updates([self.row], {"example": "2.0-1"}), [])
        self.assertEqual(updates.pending_updates([self.row], {}), [])

    def test_checkupdates_exit_codes_distinguish_failure_from_no_updates(self):
        with patch.object(updates.subprocess, "run", return_value=subprocess.CompletedProcess([], 2, "", "")):
            self.assertEqual(updates.check_updates(), [])
        with patch.object(updates.subprocess, "run", return_value=subprocess.CompletedProcess([], 1, "", "offline")):
            with self.assertRaises(RuntimeError):
                updates.check_updates()


if __name__ == "__main__":
    unittest.main()
