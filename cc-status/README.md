# cc-status for Linux

[iTerm2](https://github.com/gnachman/iTerm2)'s Claude Code hook, `cc-status`,
with a Linux port of its one macOS-only function, so it can drive the Claude
Code integration of [konsole-claude](https://github.com/destinal/konsole-claude).

`cc-status` turns Claude Code's hook events into `it2 set-status` calls. In
iTerm2, `it2` talks to iTerm2; with Konsole, a stand-in `it2` forwards the
calls to Konsole's Claude Code plugin over D-Bus.

- Source: iTerm2 `cc-status/` at commit 49936d3a515d4c78653025676305422976ee2eda, imported unchanged in the
  first commit of this history.
- Changes:
  - `agentTTYPath` finds the agent's controlling terminal through `/proc` on
    Linux instead of `sysctl`. The macOS code is unchanged.
  - The background-task count leaves out the watch Claude Code keeps on each
    artifact the session published ("live updates for artifact …"), which it
    lists as a running monitor for the life of the session. Counted, it keeps
    every such session "working" for good. This applies on macOS too.
- Tests: `swift build -c release && python3 tests/run.py` runs iTerm2's 27
  scenarios and 2 for the artifact watch; all pass on Linux with Swift 6.4.

Copyright George Nachman and the iTerm2 authors. Licensed under the GNU General
Public License, version 2 (see LICENSE), like iTerm2.
