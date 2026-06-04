# Chrome in-page nav — Vimium C (decision 8.5, resolved 2026-06-04)

Vim-style keyboard nav inside pages: link hints, tab search, hjkl scrolling.
Chosen over classic Vimium (more active, better omnibar) and over "none"
(link-following was the remaining mouse dependency).

## Install (manual — extensions are per-profile)

Web Store → "Vimium C — All by Keyboard" (id `hfjbmagddngcpeloejdejnfgbamkjaeg`).
Install in **both**:

| Chrome profile | Maps to | Workspace |
|---|---|---|
| `decisionbrain.com` (Profile 2) | work | 2 (Dell) |
| `Guillermo` (Profile 3) | personal | 7 (Retina) |

The tracking window (`second chrome`, ws 6) is a window of one of these
profiles, so it inherits the extension — nothing extra to install.

## The keys that matter

| Keys | Does |
|---|---|
| `f` / `F` | **Link hints** — open in current / new tab. The whole point. |
| `j` / `k`, `d` / `u` | Scroll line / half-page |
| `gg` / `G` | Top / bottom |
| `T` | Search open tabs (pairs with many-tab work profile) |
| `o` / `O` | Omnibar: open URL/bookmark/history in current / new tab |
| `H` / `L` | History back / forward |
| `J` / `K` | Previous / next tab |
| `x` / `X` | Close tab / reopen closed tab |
| `r` | Reload |
| `/` | In-page find (`n`/`N` next/previous) |
| `gi` | Focus first input on page |
| `i` | Insert mode — keys go to the page until `Esc` |
| `?` | Show all bindings |

`Esc` escape hatch: leaves text fields, dismisses hints, exits insert mode.

## Caveats

- Dead zones: `chrome://` pages, Web Store, PDFs — Vimium can't inject there;
  fall back to `⌘L` / `⌃Tab` built-ins.
- Sites with their own keybindings (Gmail, Jira, Grafana): add to exclusions
  as friction appears — Vimium C options → Exclusion rules. Start empty.
- No collisions with the rest of the stack: AeroSpace is Hyper-only and tmux
  bindings live behind its prefix; Vimium sees plain keys only inside Chrome.

## Version-tracking

GUI-held state, like Oryx/Raycast. After customizing (exclusions, remaps):
Vimium C options → Export — commit the JSON here as `vimium-c-settings.json`
and re-Import on a new machine. Nothing exported yet (defaults in use).
