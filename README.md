# keyboard-first

Keyboard-driven workflow for macOS: many terminals / Claude Code instances, Slack,
Chrome, IntelliJ — minimal mouse. Full spec and runbook: [HANDOFF.md](HANDOFF.md).

## Architecture (HANDOFF §2)

| Layer | Scope | Tool |
|-------|-------|------|
| In-window | Many workflows in **one** terminal window | tmux (+ tmuxinator) |
| Windows | Switch / tile / focus app windows | AeroSpace |
| In-app | Act inside the focused app | App shortcuts, IdeaVim |

Input surface: ZSA Moonlander layers + a **Hyper** key (⌃⌥⇧⌘), Raycast as
launcher/fallback. Hyper is emitted by **Moonlander firmware only** (Oryx thumb
key) — the built-in keyboard has no Hyper by design (accepted trade-off; fallback
is Raycast / ⌘Tab / `aerospace` CLI, contingency in `karabiner/`).

## Quickstart

```bash
./scripts/install.sh   # idempotent: brew installs + symlinks; prints manual steps
```

## Status

| Phase | What | Status |
|-------|------|--------|
| 0 | Repo scaffold, install script | ✅ done (2026-06-04) |
| 1 | AeroSpace (window layer) | ✅ done (2026-06-04) — §5.4 criteria pass; Hyper chords owner-confirmed; workspace assignments live. IntelliJ dialog float rules: add when one annoys (wait-and-see) |
| 2 | tmux (in-window layer) | ✅ done (2026-06-04) — §4.4 criteria pass: config + plugins load, `deploy` (3 named panes) and `cc` (2 live CC instances, TUI renders correctly) reproduce detached, sessions independent of clients |
| 3 | In-app layer (Slack / IntelliJ / Chrome) | ✅ done (2026-06-04) — ideavimrc committed + linked; cheatsheets for Slack/IntelliJ/Chrome; 8.5 resolved (Vimium C). Two manual installs pending: IdeaVim plugin, Vimium C extension (install.sh steps 5–6) |
| 4 | Enthium learning (parallel track) | 🔄 started (2026-06-04) — Enthium v14 layer spec'd in `keyboard/KEYMAP.md` (toggle layer; QWERTY stays layer 0); drill protocol + gates in `keyboard/LEARNING.md`. Owner: build/flash in Oryx, then drill daily |
| 5 | Glue + refinement (Moonlander layers, Raycast) | ⬜ |

Hard sequencing rule: **environment first on QWERTY; Enthium switch last.**

## Decision log (HANDOFF §8)

| # | Decision | Resolution | Date |
|---|----------|------------|------|
| 8.1 | Terminal emulator | **iTerm2 + tmux** (lowest friction) | 2026-06-04 |
| 8.2 | tmux prefix | **Ctrl-Space** (Moonlander key can emit it later) | 2026-06-04 |
| 8.6 | AeroSpace mod | **Hyper** (⌃⌥⇧⌘), emitted by **Moonlander firmware only** (owner is almost always on it) — no Karabiner, no system extension. Built-in keyboard fallback: Raycast / ⌘Tab / `aerospace` CLI; `karabiner/hyper.json` kept as opt-in contingency. Hyper contains Shift, so window-move is a `move` mode (Hyper-m), not mod-shift chords. | 2026-06-04 |
| 8.7 | Dotfiles manager | **Plain symlink script** (`scripts/install.sh`) | 2026-06-04 |
| 8.3 | Workspace scheme | 1 terminal, 2 work chrome, 3 intellij, 6 utilities (floating, unpinned) → **Dell**; 4 comms/media (slack + obsidian + spotify), 5 personal chrome → **Retina** (hyper-4/5 picks which shows); 7 tracking chrome → **LG**; 8 scratch pairing (no assigned apps, unpinned — e.g. terminal + intellij side by side). (Renumbered 2026-06-05: 3⇄4, 5⇄6, then 5⇄7; 8 added same day.) Pins use fallback `['x','main']` for undocked. Monitor keys: Hyper-quote throws focused *window* to next monitor (pinned workspaces can't move — force-assignment is hard), Hyper-semicolon jumps focus. (Was Hyper-period — ⌃⌥⇧⌘+period/comma/slash are macOS sysdiagnose keychords, intercepted below apps; never bind them. Diagnosed 2026-06-05.) | 2026-06-04 |
| 8.8 | tmux persistence | resurrect + continuum **on** — *starting point, iterate* | 2026-06-04 |
| 8.5 | Chrome in-page nav | **Vimium C**, in work + personal profiles (Vimari is Safari-only, so the real choice was Vimium/Vimium C vs none; link hints were the last mouse dependency). Settings export → `chrome/` once customized. | 2026-06-04 |
| 8.4 | Home-row mods | **Open** — deferred until Enthium base is fluent (Phase 4/5) |  |

## Layout

```
├── HANDOFF.md            # build spec + runbook (read this first)
├── aerospace/            # window layer config + cheatsheet
├── tmux/                 # tmux.conf + tmuxinator layouts (deploy, cc)
├── scripts/aerospace-grid.sh  # hyper-g: one-shot 2-row grid of focused workspace
├── intellij/             # ideavimrc (→ ~/.ideavimrc) + cheatsheet
├── slack/                # shortcuts cheatsheet (nothing to install)
├── chrome/               # Vimium C setup + cheatsheet (decision 8.5)
├── keyboard/KEYMAP.md    # Moonlander/Enthium layer design (Oryx source of truth)
├── keyboard/LEARNING.md  # Enthium drill protocol, switch gates, progress log
├── karabiner/hyper.json  # OPTIONAL contingency: Caps Lock → Hyper (not installed by default)
├── raycast/notes.md      # GUI-held settings, recorded by hand
└── scripts/install.sh    # idempotent bootstrap
```

Repo filenames are unhidden (`tmux/tmux.conf`, not `.tmux.conf`); `install.sh`
maps them to their dotfile locations.

## Chrome: three instances, three monitors

All Chrome windows share one bundle ID, so routing is title-based (see
`aerospace.toml` comments for the verified title formats):

- **Tracking** window is a Chrome *named window* (`second chrome` — set via
  right-click tab strip → "Name window…"; survives Chrome restarts) → ws 6 (LG).
- **Personal** profile is matched by end-anchor `Guillermo$` (work titles
  continue with `(decisionbrain.com)`) → ws 7 (Retina).
- Everything else (work profile, incognito) → ws 2 (Dell).

If the tracking window is ever recreated from scratch: re-name it `second
chrome`, then `Hyper-m → 6` once. Don't rename the personal profile in a way
that adds text after the name, or the end-anchor breaks.

## Operational notes

- **AeroSpace is pre-1.0**: read release notes before `brew upgrade`.
  Installed: **0.20.3-Beta** (2026-06-04)
- Raycast is installed outside Homebrew (self-updates); install.sh detects and
  skips it.
- Oryx and Raycast hold state in GUIs — record choices in `keyboard/KEYMAP.md` and
  `raycast/notes.md` as they're made.
