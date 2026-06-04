# Keyboard-Driven Workflow — Build Hand-off

**Owner:** Guillermo (SRE)
**Platform:** macOS, zsh, ZSA Moonlander, iTerm2 (current)
**Purpose:** A keyboard-first, mouse-as-little-as-possible workflow for multitasking across many terminals / Claude Code instances, Slack, Chrome, and IntelliJ IDEA.
**Audience:** A Claude Code instance executing the build, plus the owner reviewing/committing.

---

## 0. How to use this document

This is a build spec and runbook, not a finished config. It is ordered as a phased
rollout (Section 7). Config blocks are **starting points** meant to be committed and
then iterated — treat them as the first commit, not the last word. Anything still
undecided is collected in **Section 8 (Open decisions)**; resolve those with the owner
rather than guessing.

One hard sequencing rule that governs everything below: **get the environment (AeroSpace
+ tmux + app shortcuts) working on the current QWERTY layout FIRST. Learn the Enthium
layout as a parallel, long-lead track and only switch to it full-time once the
environment is stable.** Do not make the owner fight a new layout and a new toolchain at
the same time.

---

## 1. Goal and constraints

- **Goal:** Drive day-to-day work — running several workflows at once (deployments,
  multiple Claude Code instances, log tailing, `kubectl`), plus Slack and Chrome and the
  occasional IntelliJ session — from the keyboard, minimizing mouse use.
- **Comfort + efficiency:** Typing should be efficient (low same-finger movement, low
  redirects) and acceptably comfortable. English only.
- **Work machine:** No security-invasive hacks. Anything requiring SIP to be disabled is
  out of scope.
- **Version-tracked:** Everything that can live in a repo should (Section 6).

---

## 2. Architecture — three layers + one input surface

The requirement "several terminals in one window running separate workflows" is **not** a
window-manager job; it is a terminal-multiplexer job. The design separates cleanly into
three layers, all driven from the Moonlander:

| Layer | Scope | Owner tool |
|-------|-------|-----------|
| In-window | Many workflows inside **one** terminal window | **tmux** |
| Windows | Switch / tile / focus app **windows** | **AeroSpace** |
| In-app | Act inside the focused app without the mouse | App-native shortcuts (+ IdeaVim, optional Chrome nav) |

Input surface tying them together: **Moonlander layers + a Hyper key**, with **Raycast**
as a launcher / fallback focuser.

Key mental model: the multiple tmux panes live *inside* the one terminal window that
AeroSpace manages alongside Chrome, Slack, and IntelliJ. AeroSpace gets you *to* a window;
the in-app layer acts *inside* it.

---

## 3. Keyboard layer — Enthium on the Moonlander

### 3.1 Decision and rationale

- **Layout: Enthium** (2026, Engram/Hands Down lineage). Chosen because it is efficiency-
  first while staying comfortable: same-finger-bigram rate ~0.42% (effectively tied with
  the fastest modern layouts), with the lowest lateral-stretch and scissor figures of the
  candidates we compared, decent redirects, and it is Vim-friendly (clusters `hjkl`, pulls
  more punctuation onto the base layer).
- **Thumb-alpha:** Enthium puts `R` on a thumb key. The Moonlander's thumb cluster makes
  this nearly free.
- **Column-staggered native:** Enthium targets split/ortho ergo boards. Use **standard
  fingering** and **do NOT apply angle mod** (angle mod is a row-stagger fix; the
  Moonlander's columns are already straight).

**Honest caveats:**
- Weak redirects run higher than the headline "total redirects" number (words like
  "instead," "basically").
- Enthium's creator tunes it on a contoured board (Glove80). On the Moonlander's flat
  plate, a few rare outer-column reaches ("by," "big") will feel slightly stretchier.

### 3.2 Oryx / firmware plan

- Build the layout in **Oryx** (ZSA's web configurator), at the **firmware level** on the
  board. Keep the **OS keyboard set to QWERTY** so the laptop's built-in keyboard stays
  QWERTY (useful when mobile or when someone else uses the machine).
- **Layers to design** (detail them in `keyboard/KEYMAP.md`):
  1. **Base** — Enthium (column-staggered, standard fingering, `R` on thumb).
  2. **Navigation / window layer** — arrows; AeroSpace bindings (focus / move / resize /
     workspace switch); tmux-friendly keys.
  3. **Symbol / number layer** — coding symbols and numbers; aim for common code n-grams
     (`!= -> += ::` etc.) as comfortable rolls.
  4. **Control / leader layer (optional)** — for macros and less-frequent actions.
- **Hyper key** (Cmd+Ctrl+Opt+Shift) on a thumb or home-row key, used as the global
  app-focus / leader trigger (see Section 5).
- **Home-row mods (GACS = Gui/Alt/Ctrl/Shift)** — *optional, recommended but defer.* Big
  comfort win (modifiers without pinky reaches) but needs tapping-term tuning. Add after
  the base layout is fluent, not before. (Open decision 8.4.)

### 3.3 Version-tracking the keymap

- Oryx is a web GUI; a Claude Code agent **cannot** click through it. What CC *can* own:
  - Maintain `keyboard/KEYMAP.md` — a precise, human-readable description of every layer
    so the Oryx build is reproducible by hand.
  - Optionally hold the **exported QMK source** under `keyboard/qmk/` (Oryx can export a
    QMK keymap; ZSA also supports compiling). Track it for diffability.

### 3.4 Learning plan (parallel, long lead time)

- Drill on keybr.com / MonkeyType (set "stop on error" = word; advance to `english 5k`)
  to ~30–40 wpm **before** switching full-time.
- Expect months to reach prior speed: roughly 40 wpm after month 1, 50 after month 2,
  ~80 after a year. Switching layouts does not by itself raise the speed ceiling — the
  durable win is comfort and reduced finger travel.
- **Before going full-time, confirm you can type your login password in Enthium** or you
  risk locking yourself out.

---

## 4. In-window layer — tmux

Owns "many workflows in one window." Preferred over iTerm2 native splits because sessions
persist across crashes / disconnects (critical for long deploys and remote work), layouts
are scriptable, and behavior is identical locally and over SSH.

### 4.1 Install

```bash
brew install tmux
# tpm (plugin manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### 4.2 Starter `~/.tmux.conf`

```tmux
# Prefix: Ctrl-Space (change to taste; coordinate with the Moonlander layer)
unbind C-b
set -g prefix C-Space
bind C-Space send-prefix

# Truecolor + correct terminal type — important for Claude Code / TUI rendering
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB,*:RGB"

# Sensible base
set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on
set -g history-limit 100000
set -g mouse on
set -sg escape-time 10
set -g focus-events on

# vi copy mode
setw -g mode-keys vi
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi y send -X copy-selection-and-cancel

# Intuitive splits, keep current path
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

# vim-style pane navigation
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Reload
bind r source-file ~/.tmux.conf \; display "reloaded"

# Plugins (tpm) — install with prefix + I
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'   # save/restore sessions
set -g @plugin 'tmux-plugins/tmux-continuum'   # auto-save
set -g @continuum-restore 'on'
run '~/.tmux/plugins/tpm/tpm'
```

> NOTE: `Ctrl-Space` is a *suggestion*. If the owner wants the prefix on a Moonlander
> thumb/layer key, wire that in firmware and pick whatever the board emits. (Open
> decision 8.2.)

### 4.3 Scripted layouts (tmuxinator)

```bash
brew install tmuxinator
```

```yaml
# ~/.config/tmuxinator/deploy.yml
name: deploy
root: ~/work
windows:
  - main:
      layout: main-vertical
      panes:
        - deploy:           # the deployment command / shell
        - logs:             # e.g. stern / kubectl logs -f
        - kubectl:          # scratch kubectl pane
```

```yaml
# ~/.config/tmuxinator/cc.yml
name: cc
root: ~/work
windows:
  - claude:
      layout: tiled
      panes:
        - claude            # Claude Code instance 1
        - claude            # Claude Code instance 2
```

Run with `tmuxinator start deploy` / `tmuxinator start cc`. Each Claude Code instance is
just its own pane (or its own tmux window for more room).

### 4.4 Acceptance criteria

- One iTerm2 window can hold a deploy session and ≥2 Claude Code panes simultaneously.
- Closing/reopening iTerm2 (or dropping SSH) does not kill running sessions; reattach with
  `tmux attach`.
- `tmuxinator start deploy` and `tmuxinator start cc` reproduce their layouts.

---

## 5. Window layer — AeroSpace

i3-like tiling window manager for macOS. **Never requires disabling SIP** (it emulates its
own virtual workspaces instead of touching macOS Spaces), TOML config, multi-monitor
support, CLI-first. Note: pre-1.0 public beta — pin the version and watch the changelog.

### 5.1 Install

```bash
brew install --cask nikitabobko/tap/aerospace
# Then grant Accessibility permission when prompted (System Settings > Privacy & Security).
```

Find exact bundle IDs for the app-assignment rules with:

```bash
aerospace list-apps
```

### 5.2 Starter `~/.config/aerospace/aerospace.toml`

```toml
start-at-login = true

enable-normalization-flatten-containers = true
enable-normalization-opposite-orientation-for-nested-containers = true

accordion-padding = 30
default-root-container-layout = 'tiles'
default-root-container-orientation = 'auto'

on-focused-monitor-changed = ['move-mouse monitor-lazy-center']

[gaps]
inner.horizontal = 8
inner.vertical = 8
outer.left = 8
outer.right = 8
outer.top = 8
outer.bottom = 8

[mode.main.binding]
# Focus (vim-style). 'alt' is the mod here — see note below.
alt-h = 'focus left'
alt-j = 'focus down'
alt-k = 'focus up'
alt-l = 'focus right'

# Move focused window within the tree
alt-shift-h = 'move left'
alt-shift-j = 'move down'
alt-shift-k = 'move up'
alt-shift-l = 'move right'

# Layouts
alt-slash = 'layout tiles horizontal vertical'
alt-comma = 'layout accordion horizontal vertical'

# Switch workspace
alt-1 = 'workspace 1'   # terminal (iTerm2 + tmux)
alt-2 = 'workspace 2'   # chrome
alt-3 = 'workspace 3'   # slack
alt-4 = 'workspace 4'   # intellij
alt-5 = 'workspace 5'

# Send focused window to workspace
alt-shift-1 = 'move-node-to-workspace 1'
alt-shift-2 = 'move-node-to-workspace 2'
alt-shift-3 = 'move-node-to-workspace 3'
alt-shift-4 = 'move-node-to-workspace 4'
alt-shift-5 = 'move-node-to-workspace 5'

alt-tab = 'workspace-back-and-forth'
alt-r = 'mode resize'

[mode.resize.binding]
h = 'resize width -50'
j = 'resize height +50'
k = 'resize height -50'
l = 'resize width +50'
enter = 'mode main'
esc = 'mode main'

# --- App -> workspace assignment (VERIFY app-id via `aerospace list-apps`) ---
[[on-window-detected]]
if.app-id = 'com.googlecode.iterm2'
run = 'move-node-to-workspace 1'

[[on-window-detected]]
if.app-id = 'com.google.Chrome'
run = 'move-node-to-workspace 2'

[[on-window-detected]]
if.app-id = 'com.tinyspeck.slackmacgap'
run = 'move-node-to-workspace 3'

[[on-window-detected]]
if.app-id = 'com.jetbrains.intellij'
run = 'move-node-to-workspace 4'

# --- Float JetBrains popups/dialogs that fight tiling ---
# VERIFY the matcher key names against current AeroSpace docs before relying on this.
# [[on-window-detected]]
# if.app-id = 'com.jetbrains.intellij'
# if.window-title-regex-substring = 'Search Everywhere'
# run = 'layout floating'
```

> NOTE on the mod key: `alt` is used above (i3 convention). The Moonlander can emit `alt`
> trivially from a layer, so window control can live on the nav/window layer. Alternatively
> use the Hyper key as the AeroSpace mod. (Open decision 8.6.)

### 5.3 Multi-monitor

Use `[workspace-to-monitor-force-assignment]` if specific workspaces should pin to specific
displays. Configure once the monitor setup is confirmed.

### 5.4 Acceptance criteria

- iTerm2, Chrome, Slack, IntelliJ each open onto their assigned workspace automatically.
- Workspace switch + window focus/move/resize are fully keyboard-driven.
- IntelliJ dialogs/popups don't break the tiling layout (float rules applied as needed).
- No SIP disabling anywhere.

---

## 6. In-app layer — acting without the mouse

AeroSpace gets you to the app; these are how you work *inside* each one.

- **Slack:** built-in shortcuts.
  - `⌘K` — jump to any channel / DM / person (the workhorse).
  - `⌘⇧K` — direct messages; `⌘⇧A` — all unreads / activity.
  - Arrow keys move between messages; `⌘[` / `⌘]` navigate history.
  - `⌘/` — list all shortcuts.
- **IntelliJ IDEA:**
  - Install the **IdeaVim** plugin for modal editing (carries over Enthium + Vim muscle
    memory).
  - `⌘⇧A` — Find Action (run any IDE command by name).
  - double-`⇧` — Search Everywhere; `⌘E` — recent files; `⌘1..9` — tool windows.
  - Pair with AeroSpace float rules for its dialogs.
- **Chrome:** in-page mouseless navigation is an **open decision** — the owner does not
  currently run an extension. Options: none (rely on Chrome's built-in shortcuts +
  AeroSpace for window-level), or install a keyboard-nav extension such as Vimium C or
  Vimari for link-hint navigation. (Open decision 8.5 — do not assume an extension is
  installed.)

---

## 7. Phased rollout (build order)

> Reminder: environment first on QWERTY; Enthium switch last.

**Phase 0 — Repo scaffold**
- Create the repo structure (Section 9). Commit `HANDOFF.md` and empty/starter configs.
- Write `scripts/install.sh` (idempotent: brew installs + symlink/stow). Decide dotfiles
  manager (8.7).
- *Done when:* repo is initialized, tools list is captured, install script is runnable.

**Phase 1 — AeroSpace (window layer)**
- Install, grant Accessibility, drop in `aerospace.toml`, verify app→workspace assignment
  with real bundle IDs, tune float rules.
- *Done when:* Section 5.4 acceptance criteria pass.

**Phase 2 — tmux (in-window layer)**
- Install tmux + tpm + tmuxinator, drop in `.tmux.conf`, add `deploy.yml` / `cc.yml`,
  verify persistence and truecolor for Claude Code.
- *Done when:* Section 4.4 acceptance criteria pass.

**Phase 3 — In-app layer**
- Slack shortcuts adopted; IntelliJ + IdeaVim configured and float rules tuned; resolve the
  Chrome nav decision (8.5).
- *Done when:* common actions in Slack / Chrome / IntelliJ are reachable without the mouse.

**Phase 4 — Enthium learning (parallel track, started early)**
- Build Enthium in Oryx (firmware), keep OS QWERTY, document in `KEYMAP.md`.
- Drill daily; confirm password typable; switch full-time only after Phases 1–3 are stable.
- *Done when:* owner is on Enthium full-time at acceptable speed and password is safe.

**Phase 5 — Glue + refinement**
- Design Moonlander nav/symbol/control layers to drive AeroSpace + tmux + Hyper app-focus
  coherently (no chord collisions). Add Raycast app hotkeys as launcher/fallback. Decide on
  home-row mods (8.4). Iterate.
- *Done when:* the whole stack is driven from the keyboard and committed.

---

## 8. Open decisions (resolve with owner)

1. **Terminal emulator:** stay on iTerm2 + tmux (lowest friction, recommended) vs switch to
   WezTerm / Ghostty for native multiplexing.
2. **tmux prefix key:** `Ctrl-Space` (default suggestion) vs a Moonlander thumb/layer key.
3. **Workspace scheme:** numbered (1–5 as above) vs named; which app lives where.
4. **Home-row mods (GACS):** adopt or skip; if adopting, defer until base layout is fluent.
5. **Chrome in-page nav:** none vs Vimium C vs Vimari.
6. **AeroSpace mod key:** `alt` vs Hyper.
7. **Dotfiles manager:** GNU Stow vs chezmoi vs simple symlink script; or fold into an
   existing dotfiles repo.
8. **tmux persistence plugins:** resurrect/continuum on or off.

---

## 9. Repo structure (version-tracking)

```
keyboard-workflow/                # standalone, or a subtree of existing dotfiles
├── README.md                     # quickstart + status
├── HANDOFF.md                    # this document
├── aerospace/
│   └── aerospace.toml
├── tmux/
│   ├── .tmux.conf
│   └── tmuxinator/
│       ├── deploy.yml
│       └── cc.yml
├── keyboard/
│   ├── KEYMAP.md                 # human-readable Enthium + layer design
│   └── qmk/                      # optional: exported QMK source from Oryx
├── karabiner/                    # if used for Hyper key / app focus
├── raycast/
│   └── notes.md                  # hotkeys / setup notes
└── scripts/
    └── install.sh                # idempotent bootstrap (brew + symlinks)
```

Symlinking: GNU Stow (`stow aerospace tmux ...`) or chezmoi — owner's choice (8.7).

---

## 10. Risks & caveats

- **Enthium learning curve:** weeks-to-months of reduced speed; do not switch until the
  environment is stable; confirm the login password is typable first.
- **AeroSpace pre-1.0:** breaking changes possible across releases; pin the version and
  read release notes before upgrading.
- **IntelliJ floats:** JetBrains popups/dialogs may need explicit float rules; expect a
  little tuning.
- **Thumb load:** Enthium puts `R` on a thumb, and the workflow also leans on thumbs (Hyper,
  layer toggles, space, possibly the tmux prefix). Distribute thumb usage to avoid overuse
  strain.
- **Oryx is a web GUI:** a Claude Code agent can maintain `KEYMAP.md` and any exported QMK
  source, but the owner must build/flash the layout in Oryx themselves.

---

## 11. References

- AeroSpace — https://github.com/nikitabobko/AeroSpace (docs: https://nikitabobko.github.io/AeroSpace/guide)
- Enthium — https://layouts.wiki/layouts/2026/enthium/ and https://github.com/sunaku/enthium
- Alt-layout guide (metrics, Vim notes, learning) — https://getreuer.info/posts/keyboards/alt-layouts/
- Layout playground (test-type + metrics) — https://cyanophage.github.io/
- tmux — https://github.com/tmux/tmux ; tpm — https://github.com/tmux-plugins/tpm ; tmuxinator — https://github.com/tmuxinator/tmuxinator
- IdeaVim — https://github.com/JetBrains/ideavim
