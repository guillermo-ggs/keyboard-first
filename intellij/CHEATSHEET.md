# IntelliJ cheatsheet — tailored to this repo's ideavimrc

Leader: **Space**. Modal editing via IdeaVim; everything else through the IDE's
own shortcuts (which keep working in any mode).

## One-time setup (manual)

1. Settings → Plugins → Marketplace → **IdeaVim** → install, restart.
2. On first conflicts prompt (or Settings → Editor → Vim), hand the common
   chords to **Vim**: at minimum `⌃o` / `⌃i` (jump list), `⌃r` (redo),
   `⌃v` (visual block). Leave `⌃c` / `⌘`-anything with the IDE.
3. `~/.ideavimrc` is symlinked by `scripts/install.sh`; reload after edits
   with `Space vr` (or `:source ~/.ideavimrc`).

## Escape hatches

| Keys | Does |
|---|---|
| `⌘⇧A` | Find Action — run anything by name (the IDE's `M-x`) |
| double-`⇧` | Search Everywhere |
| `:actionlist <pat>` | (IdeaVim) list IDE action IDs for new mappings |

## Navigation

| Keys | Does |
|---|---|
| `Space e` | Recent files (the workhorse — replaces tab clicking) |
| `Space ff` / `fc` / `fs` | Goto file / class / symbol |
| `Space /` | Find in path (project-wide grep) |
| `Space fu` | Find usages |
| `gd` / `gi` / `gt` | Goto declaration / implementation / test |
| `⌃o` / `⌃i` | Jump back / forward (needs the conflict handed to Vim) |
| `⌘1` | Project tool window; `Esc` returns to the editor |
| `⌘E` | Recent files (native twin of `Space e`) |

`gt`/`gi` shadow Vim's next-tab / last-insert — deliberate; tabs are `Space e`.

## Refactor / code

| Keys | Does |
|---|---|
| `Space rn` | Rename element |
| `Space a` | Intentions / quick-fix (`⌥⏎` equivalent) |
| `Space rf` | Reformat code |
| `Space oi` | Optimize imports |
| `]d` / `[d` | Next / previous error |
| `Space q` | Show error description under cursor |

## Editing (IdeaVim emulations, no install)

| Keys | Does |
|---|---|
| `gcc` / `gc<motion>` | Toggle comment |
| `ysiw"` / `cs"'` / `ds"` | Surround: add / change / delete pairs |
| `J` | IDE smart join (merges comments, concatenations) |

## Gotchas

1. Dialogs/popups: keys go to the dialog, not Vim — `Esc` closes, `Tab` moves.
2. If a `⌃` chord does the wrong thing, check Settings → Editor → Vim and
   pick a side per shortcut.
3. AeroSpace float rules for IntelliJ dialogs: still wait-and-see (Phase 1
   note) — add to aerospace.toml when one actually annoys.
