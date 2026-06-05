# Oryx build worksheet — Enthium layer (Phase 4)

> Derived from `KEYMAP.md` (the source of truth — if they disagree, KEYMAP.md
> wins and this file is stale). One sitting, ~15 min, ~34 assignments.
>
> Every key below is identified by its **layer-0 QWERTY legend**: "`f` →
> assign `e`" means *click the physical key currently showing `f` and give it
> keycode `e` on the Enthium layer*. All assignments are plain keycodes — no
> macros, no custom shift-pairs (OS stays QWERTY; see KEYMAP.md "mechanically
> trivial").

## 0. Prep (still on layer 0)

- [ ] Open the layout in Oryx ([configure.zsa.io](https://configure.zsa.io)), logged in.
- [ ] **Record current layer-0 thumb + outer-column assignments into
      `KEYMAP.md`** (open item there: "Exact current layer-0 thumb/outer-key
      assignments are GUI state in Oryx"). Do it now while you're looking at them.
- [ ] Note which key will become the toggle (suggested: **top-right outer
      key** — low-value real estate) and what it currently holds. If it holds
      something you use, pick another spot.

## 1. Create the layer

- [ ] Add a new layer. Name it **Enthium**. Confirm it is **layer 1** and that
      every key starts transparent (`▽`). *Leave every key not listed below
      transparent* so layer-0 fixes propagate.

## 2. Toggle

- [ ] **Layer 0**, chosen toggle key → **Toggle layer → Enthium** (`TG(1)`).
- [ ] **Layer 1**: leave that same position **transparent** — it inherits the
      `TG(1)` from layer 0, which is exactly the "same key on both layers"
      true toggle KEYMAP.md asks for. Nothing to assign.
- [ ] Record the actual toggle position in `KEYMAP.md` (the `____` blank).

## 3. Alphas — left half (switch to the Enthium layer)

Top row (5):

- [ ] `q` → `q` *(same letter — assign explicitly, don't leave transparent)*
- [ ] `w` → `y`
- [ ] `e` → `o`
- [ ] `r` → `u`
- [ ] `t` → `=`

Home row (6):

- [ ] outer wide key (left of `a`, whatever layer 0 shows there) → `b`
- [ ] `a` → `c`
- [ ] `s` → `i`
- [ ] `d` → `a`
- [ ] `f` → `e`
- [ ] `g` → `-`

Bottom row (5):

- [ ] `z` → `'`
- [ ] `x` → `,`
- [ ] `c` → `.`
- [ ] `v` → `;`
- [ ] `b` → `/`

## 4. Alphas — right half

Top row (5):

- [ ] `y` → `x`
- [ ] `u` → `l`
- [ ] `i` → `d`
- [ ] `o` → `p`
- [ ] `p` → `z`

Home row (6):

- [ ] `h` → `k`
- [ ] `j` → `h`
- [ ] `k` → `t`
- [ ] `l` → `n`
- [ ] `;` → `s`
- [ ] outer wide key (right of `;`) → `w`

Bottom row (5):

- [ ] `n` → `j`
- [ ] `m` → `m` *(same letter — assign explicitly)*
- [ ] `,` → `g`
- [ ] `.` → `f`
- [ ] `/` → `v`

## 5. Thumbs

- [ ] **Right thumb, easiest reach (big red)** → `r`
- [ ] Left thumb Space: leave **transparent** (inherits layer-0 Space).
- [ ] Everything else on the thumb clusters (Hyper, Enter, Backspace, layer
      keys): leave **transparent**.

## 6. Visual check before flashing

Layer 1 should read, left→right, exactly:

```
      q y o u =   x l d p z
    b c i a e -   k h t n s w
      ' , . ; /   j m g f v
            r  ← right thumb (big red)
```

Number row, mods, and all thumb keys except `r`: transparent.

## 7. Flash + verify

- [ ] Compile in Oryx, flash via Keymapp.
- [ ] Toggle the layer; in Keymapp's live view (or a scratch buffer) type the
      full alphabet + `= - ' , . ; /` and confirm each lands per the diagram.
- [ ] Toggle works both ways (same key enters and exits the layer).
- [ ] **Type your login password on the Enthium layer** — the headline gate in
      `LEARNING.md`. (In a text editor, not the lock screen, so you can see it.)
- [ ] Hyper chords still work on the Enthium layer (transparency check):
      `Hyper-1`/`Hyper-2` switch workspaces.

## 8. Bookkeeping (back in the repo)

- [ ] `KEYMAP.md`: flip status to FLASHED with date; fill in the toggle
      position; layer plan table row 1 → flashed.
- [ ] Optional but recommended: Oryx → Download source → commit to
      `keyboard/qmk/` for diffability.
- [ ] `LEARNING.md`: log the flash date; start the drill protocol.
