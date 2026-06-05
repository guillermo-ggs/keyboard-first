# AeroSpace cheatsheet — tailored to this repo's config

Mod: **Hyper** (⌃⌥⇧⌘), the Moonlander thumb key. Escape hatch when AeroSpace
misbehaves: `aerospace reload-config` from a shell, or full restart
(`osascript -e 'quit app "AeroSpace"' && open -a AeroSpace`) — a known macOS 26
bug can leave *some* hotkeys dead until a full restart.

> **Never bind Hyper + `.` `,` `/`** — macOS reserves ⌃⌥⇧⌘ + period/comma/slash
> for sysdiagnose (period flashes the screen white and writes a ~400 MB archive
> to `/var/tmp`). Intercepted below the app layer; cannot be disabled.
> Diagnosed 2026-06-05.

## Mental model

```
monitor (Dell / Retina / LG)
└── workspace  (1-8, most pinned to a monitor)
    └── tiling tree: containers (tiles or accordion, h or v)
        └── windows           — plus floating windows outside the tree
```

Focus (`hyper-hjkl`) reaches floating windows too — they keep a position in
the tree based on screen location. Layouts persist per container until changed.

## Focus & workspaces

| Keys | Does |
|---|---|
| `Hyper-h/j/k/l` | Focus window left / down / up / right |
| `Hyper-1..8` | Workspace: 1 terminal, 2 chrome, 3 intellij, 4 comms, 5 personal, 6 utils, 7 tracking, 8 scratch |
| `Hyper-Tab` | Back-and-forth between last two workspaces |
| `Hyper-;` | Focus next monitor |
| `Hyper-'` | Throw focused window to next monitor |

## Layouts (per workspace/container)

| Keys | Does |
|---|---|
| `Hyper-s` | **S**plit: tiles layout; again toggles h ↔ v |
| `Hyper-a` | **A**ccordion: windows overlap, focused near-fullscreen, `Hyper-h/l` cycles (30px peeks) |
| `Hyper-g` | **G**rid: one-shot reshape to 2 rows (4 windows → 2×2, 6 → 3×2, 5 → 2+2+1) via `scripts/aerospace-grid.sh` |
| `Hyper-f` | **F**ullscreen toggle (AeroSpace-zoom, not macOS-native) |
| `Hyper-t` | **T**oggle floating ↔ tiled for the focused window |

Typical workspace-3 flow: 4 IntelliJ windows land as 4 unreadable columns →
`Hyper-g` for a 2×2, or `Hyper-a` to work one-at-a-time, `Hyper-s` back to columns.

## Move mode (`Hyper-m`) — stays active until Esc/Enter

| Keys | Does |
|---|---|
| `h/j/k/l` | Nudge focused window through the tree |
| `H/J/K/L` (shift) | `join-with` neighbor — manual grid building: joining a *horizontal* neighbor stacks the two *vertically* |
| `1..8` | Send window to workspace N (one-shot, exits mode) |
| `Esc` / `Enter` | Back to main mode |

## Resize mode (`Hyper-r`)

| Keys | Does |
|---|---|
| `h/l` | Width −/+ 50 |
| `j/k` | Height +/− 50 |
| `Esc` / `Enter` | Back to main mode |

## Window routing rules (on-window-detected)

- iTerm2 → 1; work Chrome → 2; personal Chrome → 5; "second chrome" named
  window → 7; Slack/Obsidian/Spotify → 4; Bitwarden/Docker → 6 (floating).
- **IntelliJ:** only main windows (title `project – file`) are routed to 3.
  Dialogs/popups (Settings, Commit, diff…) **float and stay on the workspace
  of the instance that opened them** — so an instance moved to 8 keeps its
  popups on 8. Caveat: a *new project window* opened anywhere still routes to 3.

## Debugging

| Command (shell) | Does |
|---|---|
| `aerospace list-windows --all` | Every window + title (verify routing regexes) |
| `aerospace list-windows --workspace 3` | What's on a workspace |
| `aerospace trigger-binding --mode main '<binding>'` | Fire a binding without the keyboard (separates key-delivery from command problems) |
| `aerospace flatten-workspace-tree --workspace focused` | Reset a messed-up tree to flat columns |
| `aerospace reload-config --dry-run` | Validate config without applying |
