# tmux cheatsheet — tailored to this repo's config

Prefix: **`Ctrl-Space`**, release, then the key. Literal Ctrl-Space to an app
inside tmux: `Ctrl-Space Ctrl-Space`. Escape hatch: `C-Space ?` lists all bindings.

## Mental model

```
tmux server (one, survives everything)
└── sessions   (a project/workflow: "deploy", "cc")
    └── windows  (like browser tabs, numbered from 1)
        └── panes  (splits inside a window)
```

The server runs detached from any terminal. iTerm2 crashing/closing or SSH
dropping never kills work — `tmux attach` brings it back.

## Sessions — top-level workflows

| Command (shell) | Does |
|---|---|
| `tmuxinator start deploy` | 3-pane deploy layout (deploy / logs / kubectl) in `~/dev` |
| `tmuxinator start cc` | 2 Claude Code instances side by side |
| `tmux ls` | What's running |
| `tmux attach -t cc` | Reattach |
| `tmux new -s name` | Ad-hoc new session |

| Keys | Does |
|---|---|
| `C-Space d` | **Detach** — session keeps running |
| `C-Space s` | Session picker (deploy ↔ cc) |
| `C-Space $` | Rename session |

## Windows — tabs within a session

| Keys | Does |
|---|---|
| `C-Space c` | New window |
| `C-Space 1..9` | Jump to window N (numbering starts at 1) |
| `C-Space n` / `p` | Next / previous window |
| `C-Space ,` | Rename window |
| `C-Space w` | Tree picker — all sessions + windows |
| `C-Space &` | Kill window |

Third CC instance with more room: `C-Space c`, run `claude`, flip with `C-Space 1/2`.

## Panes — splits (custom bindings)

| Keys | Does |
|---|---|
| `C-Space \|` | Split vertically (side by side), keeps cwd |
| `C-Space -` | Split horizontally (stacked), keeps cwd |
| `C-Space h/j/k/l` | Move focus between panes, vim-style |
| `C-Space z` | **Zoom** pane to full window; same key un-zooms |
| `C-Space x` | Kill pane |

Resize: drag the border (mouse on), or `C-Space` + hold `Ctrl` + arrows (default).
Mouse also works for focusing panes and scrolling.

## Copy mode — vi-style

1. `C-Space [` to enter (or mouse-scroll up)
2. `h/j/k/l` move, `Ctrl-u`/`Ctrl-d` half-pages, `/` search
3. `v` start selection → `y` yank and exit (also lands in macOS clipboard)
4. `C-Space ]` paste inside tmux
5. `q` bail out

History limit is 100k lines.

## Persistence — resurrect + continuum

- Continuum auto-saves the layout every 15 min.
- After reboot / server death: start tmux, `C-Space Ctrl-r` restores everything.
- `C-Space Ctrl-s` forces a save (do this before a risky reboot).
- Restore brings back layout + cwds, **not running processes** — restart
  `claude` / `kubectl logs -f` by hand (resurrect can auto-relaunch some
  programs; possible future iteration).

## Gotchas

1. If `Ctrl-Space` seems dead: macOS reserves it for input-source switching when
   multiple input sources are enabled (System Settings → Keyboard → Input
   Sources). English-only setup → normally inert.
2. `C-Space r` reloads tmux.conf in place — use it when iterating on the config.
3. `C-Space I` installs tpm plugins after adding one to tmux.conf.
