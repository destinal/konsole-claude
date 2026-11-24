# konsole-claude (Jason's fork)

Konsole with a Claude Code integration modeled on iTerm2's: status dots on tabs, a Claude Sessions panel, notifications, Diff/Code Review workgroups, Clippings. **Upstream is Eric Duprey's** `destinal/konsole-claude`; Jason works in a fork (`jasondma/konsole-claude`, remote `fork`) to build and run it on Kubuntu 26.04.

## Repos and branches
- This repo: `main` tracks upstream (`origin`). Jason's work is on **`kubuntu-build`** (pushed to `fork`): Kubuntu install docs and package release 4.
- `konsole/` is a **separate git checkout** (gitignored here) of the Konsole source on branch `claude-integration`, remotes `origin` (destinal/konsole) and `fork` (jasondma/konsole). Code changes to Konsole and the plugin (`konsole/src/plugins/ClaudeCode/`) are made there, then exported as `packaging/0*.patch`.
- `cc-status/` is iTerm2's hook ported to Linux (Swift).
- `aur/publish.sh` pushes to the AUR **as Eric Duprey, with his account**. Never run it.

## Install on this machine
Built into `~/.local/opt/konsole-claude` and started as `konsole-claude`, beside apt's `konsole` (which keeps updating). The full Kubuntu steps are in `README.md` on `kubuntu-build`: apt build deps, Swift via swiftly (`. ~/.local/share/swiftly/env.sh`), apply `packaging/0*.patch` to the Konsole tarball, `cmake -G Ninja` with `-DCMAKE_INSTALL_PREFIX=~/.local/opt/konsole-claude`, then build `cc-status` statically and install it beside `claude-code-hook`.

## It edits `~/.claude/settings.json`
`konsole-claude-setup install` (or **Install Hooks** in the Sessions panel) writes hooks for ~10 Claude Code events, all running `~/.local/opt/konsole-claude/lib/x86_64-linux-gnu/libexec/konsole-claudecode/claude-code-hook`, and backs up settings first. On 2026-11-23 Jason fixed it mangling non-ASCII characters in settings.json (konsole commit `edb5f4b`, package release 4).
- `~/.claude` is backed up to the private `jasondma/claude-config` repo, so hook changes show up there. A restore on another machine needs konsole-claude installed, or those hooks fail.
- After changing hook or settings code, diff `~/.claude/settings.json` against `git -C ~/.claude show HEAD:settings.json` to confirm nothing else (model, `autoMode`, permissions) was rewritten.

## Working rules
- Ask before pushing to `fork`, and never push to `origin` or open PRs against `destinal/*` without Jason saying so; that's someone else's project.
- This CLAUDE.md is Jason's, not upstream's. Keep it out of anything proposed upstream.
- Konsole tests, as `packaging/update-konsole.sh` runs them, inside `konsole/`: `cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_TESTING=ON`, build, then `QT_QPA_PLATFORM=offscreen ctest --test-dir build --output-on-failure -E TerminalInterfaceTest`.
- `cc-status` tests are a Python runner, `cc-status/tests/run.py` (there is no Swift test target). Read it for usage before running.
