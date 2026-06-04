# Raycast — launcher / fallback focuser

Role in the stack (HANDOFF §2, §7 Phase 5): app launcher and *fallback* focuser.
AeroSpace workspaces (Hyper-1..5) are the primary way to reach an app; Raycast
covers everything else (launch-by-name, clipboard history, window fallback).

## Setup notes

- Installed via `scripts/install.sh` (`brew install --cask raycast`).
- Raycast settings aren't plain-text trackable; export a `.rayconfig` backup
  periodically (Raycast → Settings → Advanced → Export) — do **not** commit it if
  it contains tokens/secrets.

## Suggested hotkeys (configure in Raycast GUI; record final choices here)

| Action | Suggestion | Note |
|---|---|---|
| Raycast root | `⌘ Space` | Replaces Spotlight (disable Spotlight's hotkey in System Settings) |
| Clipboard history | `Hyper-v`? | Verify no collision with AeroSpace main-mode bindings |

Keep this table updated as Phase 5 lands — it is the record of what the GUI holds.
