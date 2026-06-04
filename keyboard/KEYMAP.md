# Moonlander keymap — Enthium + workflow layers

> **Status: NOT YET BUILT.** This is the design doc for the Phase 4 Oryx build.
> Oryx is a web GUI — an agent cannot drive it. This file is the source of truth:
> it must describe every layer precisely enough that the Oryx build is reproducible
> by hand. Update it on every keymap change; optionally export the QMK source from
> Oryx into `keyboard/qmk/` for diffability.

## Principles (HANDOFF §3)

- **Base layout: Enthium** — column-staggered native, **standard fingering**,
  **no angle mod**, `R` on a thumb key.
- OS keyboard layout stays **QWERTY** (laptop's built-in keyboard unaffected).
- Environment first: the Enthium switch happens only after Phases 1–3 are stable.
- Watch thumb load: `R`, space, layer toggles, and Hyper all compete for thumbs.

## Hyper key (decision 8.6 — resolved 2026-06-04)

Hyper = ⌃⌥⇧⌘ — the AeroSpace mod (see `aerospace/aerospace.toml`).

| Input surface | How Hyper is emitted |
|---|---|
| Moonlander | Dedicated thumb key, Oryx built-in Hyper keycode |
| Built-in laptop keyboard | Hold Caps Lock via Karabiner (`karabiner/hyper.json`); tap = Esc |

## Layers (planned — fill in as built)

| # | Layer | Contents |
|---|-------|----------|
| 0 | Base | Enthium alphas, `R` on thumb, punctuation per Enthium spec |
| 1 | Nav / window | Arrows; Hyper chords for AeroSpace (h/j/k/l, 1–5, m, r, tab); `Ctrl-Space` (tmux prefix) on a comfortable key |
| 2 | Symbols / numbers | Coding symbols + numbers; common code n-grams (`!=`, `->`, `+=`, `::`) as rolls |
| 3 | Control / leader | Macros, rare actions (optional) |

## Open decisions affecting this keymap

- **8.4 Home-row mods (GACS):** recommended but deferred until the Enthium base is
  fluent; needs tapping-term tuning.
- tmux prefix placement: `Ctrl-Space` is the prefix (decision 8.2); decide later
  whether a dedicated thumb/layer key should emit it as a single press.

## Learning plan

See HANDOFF §3.4 — keybr.com / MonkeyType drills to ~30–40 wpm before switching
full-time; **confirm the login password is typable in Enthium first**.
