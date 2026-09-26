"""Unit + real-server tests. Never connects to the user's Herdr session.
Run: python3 ~/.config/herdr/tests/test_layout.py
"""
import importlib.machinery
import importlib.util
import os
from pathlib import Path
import subprocess
import tempfile
import time
import unittest

HELPER = Path(__file__).resolve().parents[1] / "bin/herdr-layout"
loader = importlib.machinery.SourceFileLoader("layout", str(HELPER))
spec = importlib.util.spec_from_loader(loader.name, loader)
layout = importlib.util.module_from_spec(spec)
loader.exec_module(layout)


def pane(name):
    return {"type": "pane", "pane_id": name}


def split(direction, first, second, ratio=0.5):
    return {"type": "split", "direction": direction, "ratio": ratio, "first": first, "second": second}


def tree():
    return split("right", pane("a"), split("down", pane("b"), split("down", pane("c"), pane("d"))))


class PlannerTests(unittest.TestCase):
    def test_balance_columns_and_three_rows(self):
        plan = dict(layout.balance_plan(tree()))
        self.assertEqual(plan[()], 0.5)
        self.assertAlmostEqual(plan[(True,)], 1/3)
        self.assertEqual(plan[(True, True)], 0.5)

    def test_maximize_middle_changes_only_column(self):
        self.assertEqual(dict(layout.vertical_plan(tree(), "c")), {(True,): 0.1, (True, True): 0.9})

    def test_maximize_top_balances_unused_siblings(self):
        self.assertEqual(dict(layout.vertical_plan(tree(), "b")), {(True,): 0.9, (True, True): 0.5})

    def test_full_height_pane_has_no_resize(self):
        self.assertEqual(layout.vertical_plan(tree(), "a"), [])

    def test_single_pane(self):
        self.assertEqual(layout.balance_plan(pane("a")), [])
        self.assertEqual(layout.vertical_plan(pane("a"), "a"), [])

    def test_shared_row_does_not_distort_adjacent_column(self):
        root = split("down", split("right", pane("a"), pane("b")), pane("c"))
        self.assertEqual(layout.vertical_plan(root, "a"), [])

    def test_unknown_pane_fails(self):
        with self.assertRaises(RuntimeError):
            layout.vertical_plan(tree(), "missing")

    def test_topology_change_stops_before_mutating(self):
        class Changed:
            def call(self, method, **params):
                assert method == "layout.export"
                return {"layout": {"root": pane("replacement")}}
        with self.assertRaisesRegex(RuntimeError, "Layout changed"):
            layout.apply_plan(Changed(), {"tab_id": "t1", "root": tree()}, layout.balance_plan(tree()))


class LiveServerTests(unittest.TestCase):
    def test_resize_preserves_live_panes(self):
        with tempfile.TemporaryDirectory(prefix="herdr-layout-test-") as tmp:
            env = {k: v for k, v in os.environ.items() if not k.startswith("HERDR_")}
            env.update(XDG_CONFIG_HOME=tmp, XDG_CACHE_HOME=tmp, XDG_STATE_HOME=tmp, XDG_DATA_HOME=tmp, SHELL="/bin/sh")
            config = Path(tmp) / "herdr/config.toml"
            config.parent.mkdir()
            config.write_text('onboarding = false\n[terminal]\ndefault_shell = "/bin/sh"\n[update]\nversion_check = false\nmanifest_check = false\n')
            socket_path = Path(tmp) / "herdr/sessions/layout-test/herdr.sock"
            client = layout.Client(str(socket_path))
            with (Path(tmp) / "server.log").open("w+") as log:
                server = subprocess.Popen(["herdr", "--session", "layout-test", "server"], env=env, cwd=tmp, stdout=log, stderr=log)
                try:
                    for _ in range(100):
                        if socket_path.exists() or server.poll() is not None:
                            break
                        time.sleep(0.1)
                    self.assertIsNone(server.poll(), "isolated server failed to start")
                    self.assertTrue(socket_path.exists())
                    a = client.call("workspace.create", label="layout test", cwd=tmp, focus=True)["root_pane"]["pane_id"]
                    b = client.call("pane.split", target_pane_id=a, direction="right", focus=False)["pane"]["pane_id"]
                    c = client.call("pane.split", target_pane_id=b, direction="down", focus=False)["pane"]["pane_id"]
                    d = client.call("pane.split", target_pane_id=c, direction="down", focus=False)["pane"]["pane_id"]
                    ids = (a, b, c, d)
                    before = {p: client.call("pane.get", pane_id=p)["pane"]["terminal_id"] for p in ids}
                    pids = {p: client.call("pane.process_info", pane_id=p)["process_info"]["shell_pid"] for p in ids}
                    original = client.call("layout.export", pane_id=a)["layout"]

                    def snapshot():
                        return client.call("layout.export", pane_id=a)["layout"]

                    layout.resize(client, b, "balance")
                    self.assertAlmostEqual(snapshot()["root"]["second"]["ratio"], 1/3, places=5)
                    layout.resize(client, b, "focus")
                    self.assertAlmostEqual(snapshot()["root"]["second"]["ratio"], 0.9, places=5)
                    for source, direction, target in ((b, "down", c), (c, "down", d), (d, "up", c), (c, "left", a)):
                        layout.resize(client, source, direction)
                        self.assertEqual(snapshot()["focused_pane_id"], target)
                        self.assertEqual(snapshot()["root"]["ratio"], 0.5)
                    layout.resize(client, a, "right")
                    self.assertIn(snapshot()["focused_pane_id"], (b, c, d))
                    # No neighbor: expand the source without jumping elsewhere.
                    layout.resize(client, b, "up")
                    self.assertEqual(snapshot()["focused_pane_id"], b)
                    client.call("pane.zoom", pane_id=c, mode="on")
                    layout.resize(client, c, "balance")
                    self.assertFalse(snapshot()["zoomed"])
                    self.assertEqual(layout.shape(snapshot()["root"]), layout.shape(original["root"]))
                    for p in ids:
                        self.assertEqual(client.call("pane.get", pane_id=p)["pane"]["terminal_id"], before[p])
                        self.assertEqual(client.call("pane.process_info", pane_id=p)["process_info"]["shell_pid"], pids[p])
                    # Exercise the adjacent entrypoint and its invocation context.
                    run_env = dict(env, HERDR_ACTIVE_PANE_ID=c, HERDR_SOCKET_PATH=str(socket_path), XDG_RUNTIME_DIR=tmp)
                    subprocess.run([str(HELPER), "focus"], env=run_env, check=True, capture_output=True, timeout=10)
                    self.assertEqual(snapshot()["focused_pane_id"], c)
                finally:
                    if socket_path.exists() and server.poll() is None:
                        client.call("server.stop")
                    try:
                        server.wait(timeout=5)
                    except subprocess.TimeoutExpired:
                        # Only our isolated child process, never the user's server.
                        server.terminate()
                        server.wait(timeout=5)


if __name__ == "__main__":
    unittest.main()
