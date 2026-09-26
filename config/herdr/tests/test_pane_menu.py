"""Run: python3 ~/.config/herdr/tests/test_pane_menu.py"""
import importlib.machinery
import importlib.util
import os
from pathlib import Path
import subprocess
import unittest
from unittest.mock import patch

PATH = Path(__file__).resolve().parents[1] / "bin/herdr-pane-menu"
loader = importlib.machinery.SourceFileLoader("pane_menu", str(PATH))
spec = importlib.util.spec_from_loader(loader.name, loader)
menu = importlib.util.module_from_spec(spec)
loader.exec_module(menu)

PANE = {"pane_id": "w1:p1", "tab_id": "w1:t1", "workspace_id": "w1", "label": "old"}
TABS = [
    {"tab_id": f"w1:t{i}", "number": i, "label": "same", "pane_count": 2}
    for i in range(1, 4)
]


class MenuTests(unittest.TestCase):
    def setUp(self):
        env = patch.dict(os.environ, {"HERDR_ACTIVE_PANE_ID": "w1:p1", "HERDR_PANE_ID": "wrong"})
        env.start()
        self.addCleanup(env.stop)
        self.calls = []

    def api(self, *args):
        self.calls.append(args)
        if args[:2] == ("pane", "get"):
            return {"pane": PANE.copy()}
        if args[:2] == ("tab", "list"):
            return {"tabs": TABS.copy()}
        return {"move_result": {"changed": True}}

    def run_menu(self, choices, query=None):
        with patch.object(menu, "api", side_effect=self.api), \
             patch.object(menu, "choose", side_effect=choices) as choose, \
             patch.object(menu, "finder", return_value=query):
            menu.main()
        return choose

    def test_cancel_menu(self):
        self.run_menu([None])
        self.assertEqual(self.calls, [("pane", "get", "w1:p1")])

    def test_move_existing_excludes_source_and_keeps_duplicate_labels(self):
        choose = self.run_menu(["move", "w1:t3"])
        self.assertEqual([item[0] for item in choose.call_args_list[1].args[0]], ["w1:t2", "w1:t3", "new"])
        self.assertEqual(self.calls[-1], ("pane", "move", "w1:p1", "--tab", "w1:t3", "--split", "right", "--focus"))

    def test_move_new(self):
        self.run_menu(["move", "new"])
        self.assertEqual(self.calls[-1], ("pane", "move", "w1:p1", "--new-tab", "--focus"))

    def test_cancel_destination(self):
        self.run_menu(["move", None])
        self.assertFalse(any(call[:2] == ("pane", "move") for call in self.calls))

    def test_rename_literal(self):
        self.run_menu(["rename"], ["-name; $(not-a-command)", "hint"])
        self.assertEqual(self.calls[-1], ("pane", "rename", "w1:p1", "--", "-name; $(not-a-command)"))

    def test_clear_label(self):
        self.run_menu(["rename"], ["", "hint"])
        self.assertEqual(self.calls[-1], ("pane", "rename", "w1:p1", "--clear"))

    def test_cancel_rename(self):
        self.run_menu(["rename"], None)
        self.assertFalse(any(call[:2] == ("pane", "rename") for call in self.calls))

    def test_missing_context_fails_closed(self):
        with patch.dict(os.environ, {}, clear=True), patch.object(menu, "api") as api:
            with self.assertRaises(RuntimeError):
                menu.main()
            api.assert_not_called()

    def test_choose_returns_id_not_label(self):
        with patch.object(menu, "finder", return_value=["1\tsame"]):
            self.assertEqual(menu.choose([("t2", "same"), ("t3", "same")], "", ""), "t3")

    def test_display_sanitizes_controls(self):
        self.assertEqual(menu.display("a\nb\t\x1b"), "a b  ")

    def test_fzf_cancellation_and_error(self):
        for status in (1, 130, 2):
            with patch.object(subprocess, "run", return_value=subprocess.CompletedProcess([], status, "")):
                if status == 2:
                    with self.assertRaises(RuntimeError):
                        menu.finder(["a"], "", "")
                else:
                    self.assertIsNone(menu.finder(["a"], "", ""))

    def test_layout_menu_actions_delegate(self):
        for action in ("focus", "balance"):
            with patch.object(subprocess, "run", return_value=subprocess.CompletedProcess([], 0, "", "")) as run:
                self.run_menu([action])
                self.assertEqual(run.call_args.args[0], [str(PATH.with_name("herdr-layout")), action])

    def test_api_error(self):
        with patch.object(subprocess, "run", return_value=subprocess.CompletedProcess([], 1, "", "missing pane")):
            with self.assertRaisesRegex(RuntimeError, "missing pane"):
                menu.api("pane", "get", "gone")


if __name__ == "__main__":
    unittest.main()
