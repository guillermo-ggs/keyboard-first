# Enthium learning track — Phase 4 (started 2026-06-04)

Parallel, long-lead track (HANDOFF §3.4). The environment (Phases 1–3) is done
and stable; this is the last piece before Phase 5 glue. **No deadline pressure:
QWERTY stays layer 0 the whole time** — Enthium is a toggle layer you visit for
drills, then increasingly for real work, until the switch earns itself.

## Why drills happen on the board (not a website setting)

The remap is in firmware and the OS stays QWERTY, so *any* typing site works:
toggle the Enthium layer and type what's on screen. Never set a website's
"layout" option to Enthium — that would double-remap.

## Protocol

1. **Flash first** (see manual steps in `KEYMAP.md`): Enthium on layer 1 +
   toggle key.
2. **keybr.com first** — it unlocks letters progressively and drills weak ones
   (expect thumb-`R` and outer-column `b`/`w` to lag). Settings: layout
   **QWERTY** (see above), enable "stop on error".
3. **Graduate to MonkeyType** once keybr has unlocked all letters: english →
   english 1k → english 5k, "stop on error" = word.
4. **Code-shaped practice** near the end: cyanophage playground
   (https://cyanophage.github.io/) test-type, or MonkeyType code modes — the
   punctuation row (`' , . ; /`) and `=`/`-` matter for this workflow.
5. **15–20 min/day, every day.** Short daily sessions beat long rare ones.
   Stop a session when accuracy collapses — fatigue trains errors.
6. Log weekly in the table below.

## Hard gates before the full-time switch (rebuild layer order)

- [ ] **Password gate:** type the login password on the Enthium layer into a
      blank TextEdit note, 5/5 successes, no peeking. (Low lockout risk while
      QWERTY is layer 0 — the board reboots into QWERTY and the built-in
      keyboard is always QWERTY — but the gate must pass before the swap.)
- [ ] ~30–40 wpm sustained on MonkeyType english 5k, ≥95% accuracy.
- [ ] A full real workday spent on the Enthium layer (toggled by hand) without
      reaching for the toggle out of frustration more than a handful of times.

## Expectations (HANDOFF §3.4 — calibrate, don't panic)

| Time on layout | Typical speed |
|---|---|
| Month 1 | ~40 wpm |
| Month 2 | ~50 wpm |
| Year 1 | ~80 wpm |

The switch doesn't raise the speed ceiling — the durable win is comfort and
reduced finger travel. Plateaus are normal; accuracy first, speed follows.

## Progress log

| Date | Tool | Speed (wpm) | Accuracy | Notes |
|---|---|---|---|---|
| 2026-06-04 | — | — | — | Track started; layer spec written, Oryx build pending |
