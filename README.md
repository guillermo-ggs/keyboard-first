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
| 1 | AeroSpace (window layer) | 🔶 nearly done — running with Accessibility; config loaded (modes main/move/resize); all 4 bundle IDs + workspace assignments verified via CLI (2026-06-04). Remaining: physical Hyper-chord test, float-rule tuning as needed |
| 2 | tmux (in-window layer) | 🔶 installed + linked; remaining: tpm plugins (prefix+I), verify §4.4 |
| 3 | In-app layer (Slack / IntelliJ / Chrome) | ⬜ |
| 4 | Enthium learning (parallel track) | ⬜ start drills anytime |
| 5 | Glue + refinement (Moonlander layers, Raycast) | ⬜ |

Hard sequencing rule: **environment first on QWERTY; Enthium switch last.**

## Decision log (HANDOFF §8)

| # | Decision | Resolution | Date |
|---|----------|------------|------|
| 8.1 | Terminal emulator | **iTerm2 + tmux** (lowest friction) | 2026-06-04 |
| 8.2 | tmux prefix | **Ctrl-Space** (Moonlander key can emit it later) | 2026-06-04 |
| 8.6 | AeroSpace mod | **Hyper** (⌃⌥⇧⌘), emitted by **Moonlander firmware only** (owner is almost always on it) — no Karabiner, no system extension. Built-in keyboard fallback: Raycast / ⌘Tab / `aerospace` CLI; `karabiner/hyper.json` kept as opt-in contingency. Hyper contains Shift, so window-move is a `move` mode (Hyper-m), not mod-shift chords. | 2026-06-04 |
| 8.7 | Dotfiles manager | **Plain symlink script** (`scripts/install.sh`) | 2026-06-04 |
| 8.3 | Workspace scheme | Numbered 1–5: 1 terminal, 2 chrome, 3 comms/media (slack + obsidian + spotify), 4 intellij, 5 utilities (bitwarden + docker, floating). Mattermost/Claude desktop deliberately unassigned. | 2026-06-04 |
| 8.8 | tmux persistence | resurrect + continuum **on** — *starting point, iterate* | 2026-06-04 |
| 8.4 | Home-row mods | **Open** — deferred until Enthium base is fluent (Phase 4/5) |  |
| 8.5 | Chrome in-page nav | **Open** — resolve in Phase 3 (none vs Vimium C vs Vimari) |  |

## Layout

```
├── HANDOFF.md            # build spec + runbook (read this first)
├── aerospace/            # window layer config
├── tmux/                 # tmux.conf + tmuxinator layouts (deploy, cc)
├── keyboard/KEYMAP.md    # Moonlander/Enthium layer design (Oryx source of truth)
├── karabiner/hyper.json  # OPTIONAL contingency: Caps Lock → Hyper (not installed by default)
├── raycast/notes.md      # GUI-held settings, recorded by hand
└── scripts/install.sh    # idempotent bootstrap
```

Repo filenames are unhidden (`tmux/tmux.conf`, not `.tmux.conf`); `install.sh`
maps them to their dotfile locations.

## Operational notes

- **AeroSpace is pre-1.0**: read release notes before `brew upgrade`.
  Installed: **0.20.3-Beta** (2026-06-04)
- Raycast is installed outside Homebrew (self-updates); install.sh detects and
  skips it.
- Oryx and Raycast hold state in GUIs — record choices in `keyboard/KEYMAP.md` and
  `raycast/notes.md` as they're made.
