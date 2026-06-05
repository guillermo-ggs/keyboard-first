# Moonlander keymap — Enthium + workflow layers

> **Status: DESIGNED, NOT YET FLASHED** (Phase 4 started 2026-06-04). Oryx is a
> web GUI — an agent cannot drive it, and Oryx has **no file import** (verified
> 2026-06-05 against its API; no Moonlander Enthium layouts or layer templates
> to fork either). Build by hand using the click-by-click worksheet in
> [`ORYX-BUILD.md`](ORYX-BUILD.md). This file is the source of truth: it must
> describe every layer precisely enough that the Oryx build is reproducible by
> hand. Update it on every keymap change; optionally export the QMK source from
> Oryx into `keyboard/qmk/` for diffability.

## Principles (HANDOFF §3)

- **Base layout: Enthium v14** — column-staggered native, **standard fingering**,
  **no angle mod**, `R` on a thumb key.
- OS keyboard layout stays **QWERTY** (laptop's built-in keyboard unaffected).
- Environment first: the full-time Enthium switch happens only after fluency
  (see `LEARNING.md`); until then **QWERTY remains firmware layer 0** and
  Enthium lives on a toggle layer.
- Watch thumb load: `R`, space, layer toggles, and Hyper all compete for thumbs.

## Hyper key (decision 8.6 — resolved 2026-06-04, refined same day)

Hyper = ⌃⌥⇧⌘ — the AeroSpace mod (see `aerospace/aerospace.toml`). Emitted by
**Moonlander firmware only** — no Karabiner, no system extension.

| Input surface | How Hyper is emitted |
|---|---|
| Moonlander | Dedicated thumb key — **L s2** (decided 2026-06-05, see thumb plan below), dual-function: **hold = Hyper** (Oryx built-in / QMK `KC_HYPR`), **tap = Esc**. Esc-tap is near-free: Hyper is never tapped alone, so misfire risk is minimal. |
| Built-in laptop keyboard | Not emitted — accepted trade-off (owner is almost always on the Moonlander). Fallbacks: Raycast, ⌘Tab, `aerospace` CLI. Opt-in contingency if ever needed: install Karabiner-Elements + `karabiner/hyper.json`. |

## Thumb cluster plan (decided 2026-06-05, spans layers 0+1)

Naming: each cluster = the **big red** piano key + three small keys
**s1/s2/s3**, numbered by distance from the red key (s1 nearest, s3
farthest). Owner's comfort ranking — recorded 2026-06-05, contrary to the
usual Moonlander assumption — is **s1 > s2 > red ≈ s3**: the reds are
uncomfortable for him, so they carry only discrete/occasional presses,
never flow keys.

| Key | Layer 0 (QWERTY) | Enthium layer | Notes |
|---|---|---|---|
| L s1 | `Space` | ▽ | most frequent key on the best key |
| L s2 | `Hyper` (hold) / `Esc` (tap) | ▽ | held not tapped; cross-hand with `Hyper-hjkl`; vim-style left-thumb Esc |
| L red | `Ctrl-Space` one-shot (tmux prefix) — **tentative** | ▽ | discrete, occasional press; resolves HANDOFF 8.2 if it sticks |
| L s3 | spare | ▽ | parking lot |
| R s1 | `Enter` | **`r`** | prime spot does double duty: Enter through the QWERTY era, `r` once full-time Enthium |
| R s2 | `Backspace` | ▽ | **permanent home — never moves** across layers or the switch (backspace spikes during drills) |
| R red | `Enter` (permanent home) — **tentative** | ▽ (`Enter`) | a discrete press is the most red-tolerable big function; on the Enthium layer this is the *only* Enter. Fallback if red-Enter grates: L red (alternates with thumb-`r` at a shell prompt) |
| R s3 | spare (`Del`?) | ▽ | parking lot |

Why `r` on **R s1, not the big red**: Enthium only requires "right thumb,
easiest reach" — for this owner that is s1. Keeping `r` on the *right*
thumb (vs the owner's first instinct, L s1) preserves the Space(L)↔`r`(R)
hand alternation: word endings like "for ", "her ", "are " stay cross-hand
rolls instead of same-thumb hops — the thumb equivalent of the same-finger
bigrams Enthium is designed to avoid.

> The currently *flashed* layer-0 thumb assignments were never recorded and
> may differ — reconcile against this table during the next Oryx session
> (worksheet §5 covers it).

## Layer plan

| # | Layer | Status | Contents |
|---|-------|--------|----------|
| 0 | QWERTY base | flashed (Phase 1) | Current working layout + Hyper thumb. Stays default until full-time switch. |
| 1 | **Enthium** | **build now (Phase 4)** | Spec below. Entered via `TG(1)` toggle. |
| 2 | Nav / window | Phase 5 | Arrows; tmux-friendly keys; `Ctrl-Space` single-press if wanted (8.2 note). |
| 3 | Symbols / numbers | Phase 5 | Coding symbols + numbers; common code n-grams (`!=`, `->`, `+=`, `::`) as rolls. |

When the full-time switch happens: rebuild with Enthium as layer 0 and QWERTY
as the toggle layer (Oryx makes reordering easy); update this table.

## Layer 1 — Enthium v14 (the Phase 4 build)

Source: https://github.com/sunaku/enthium (v14, "Engrammer meets Promethium").
Verified 2026-06-04. Canonical diagram:

```
      q y o u =   x l d p z
    b c i a e -   k h t n s w
      ' , . ; /   j m g f v
            r  ← right thumb
```

### Mapping onto the Moonlander

Alpha block = main-grid rows 2–4 (row 1 = number row, unchanged from layer 0).
Enthium's five core columns sit on the same physical columns as QWERTY alphas;
the outer (wide) column carries `b` / `w` on the home row only.

**Left half** (columns outer → inner):

| Row | outer | pinky | ring | middle | index | inner |
|---|---|---|---|---|---|---|
| 2 (top) | *keep L0* | `q` | `y` | `o` | `u` | `=` |
| 3 (home) | **`b`** | `c` | `i` | `a` | `e` | `-` |
| 4 (bottom) | *keep L0* | `'` | `,` | `.` | `;` | `/` |

**Right half** (columns inner → outer):

| Row | inner | index | middle | ring | pinky | outer |
|---|---|---|---|---|---|---|
| 2 (top) | `x` | `l` | `d` | `p` | `z` | *keep L0* |
| 3 (home) | `k` | `h` | `t` | `n` | `s` | **`w`** |
| 4 (bottom) | `j` | `m` | `g` | `f` | `v` | *keep L0* |

**Thumbs:** see the "Thumb cluster plan" section above. On this layer the
only thumb assignment is **`r` on R s1**; every other thumb key stays
**transparent (`▽`)** so layer-0 fixes propagate.

**Toggle:** one `TG(1)` key, same position on both layers so it's a true
toggle. Suggested: top-right outer key (low-value real estate). Record the
actual position here once placed: `____`.

### Why this build is mechanically trivial

Enthium's punctuation shift-pairs are identical to QWERTY scancode shift-pairs
(`=+  -_  '"  ,<  .>  ;:  /?`). Since the OS stays QWERTY, every key on this
layer is a plain QWERTY keycode placed in a new position — no macros, no
custom shifted keys, no OS-side layout change. The Oryx build is ~33 key
assignments.

### Fingering notes (HANDOFF §3.1)

- Standard fingering, **no angle mod** (Moonlander columns are already straight).
- Vim cluster: `h` right-index home, `k`/`j` right-inner home/bottom, `l`
  right-index top — all adjacent.
- `b`/`w` on outer-column home row are lateral pinky reaches — the known
  Moonlander-vs-Glove80 trade-off (HANDOFF §3.1 caveats); acceptable.
- `r` on right thumb (R s1) is new motor learning — expect it to lag the
  other keys in drills (keybr will surface this).

## Open decisions affecting this keymap

- **8.4 Home-row mods (GACS):** recommended but deferred until the Enthium base
  is fluent; needs tapping-term tuning.
- tmux prefix placement (8.2): **tentative — L red emits `Ctrl-Space` as a
  single press** (see thumb plan). Confirm after a week of real use, then mark
  8.2 resolved in HANDOFF.
- Enter's permanent (post-switch) home: **tentative — R red** (thumb plan);
  fallback L red if the red press grates even for discrete Enter.
- Exact current layer-0 **outer-column** assignments are GUI state in Oryx —
  record them here (or export QMK to `keyboard/qmk/`) next time Oryx is open.
  Thumb keys now have a designed target (thumb plan above); reconcile the
  flashed state against it in the same session (worksheet §5).

## Learning plan

Moved to `keyboard/LEARNING.md` (drill protocol, milestones, progress log).
Headline rule: **confirm the login password is typable on the Enthium layer
before any full-time switch.**
