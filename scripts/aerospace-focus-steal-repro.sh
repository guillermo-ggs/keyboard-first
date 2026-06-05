#!/bin/sh
# Repro / verification loop for the Chrome focus-steal bug (diagnosed 2026-06-05).
#
# Symptom: hyper-7 (workspace 7, tracking chrome on LG) sometimes also flipped
# the Retina display from workspace 4 to 5.
#
# Mechanism (verified live): windows of ONE Chrome app spread across
# workspaces. `workspace X` AXRaises the target window and activates Chrome;
# Chromium then re-keys its most-recently-used window (makeKeyAndOrderFront).
# If that MRU window lives elsewhere, AeroSpace follows the focus event and
# switches that monitor too. Steal target follows Chrome's MRU window.
#
# Upstream: nikitabobko/AeroSpace#726 (open as of 0.20.3-Beta). Maintainer-
# endorsed alternative: disable "Displays have separate Spaces" (logout needed).
# Mitigation applied 2026-06-05: personal (ws 5) moved to Chrome Beta — a
# separate app, so 5<->7 steals are impossible once migration is done.
#
# Test A (original symptom, ws5 MRU -> hyper-7): retina must NOT flip to 5.
#   A steal to ws2 instead is the accepted residual (reported, not a failure).
# Test B (residual, ws2 MRU -> hyper-7): work + tracking share regular Chrome,
#   so this steals to ws2 — RESIDUAL ACCEPTED by owner 2026-06-05 (recover
#   with hyper-tab). Informational only; revisit (third browser for tracking,
#   or disable "Displays have separate Spaces") if it starts to bite.
#
# Run with all monitors attached and the chrome windows open.
# Exit code = number of Test-A failures (5-steals) only.

set -u
PATH="/opt/homebrew/bin:$PATH"

check() { # $1=label $2=poison-ws ; returns 0=pass 1=fail(5-steal) 2=residual
  aerospace workspace "$2"; sleep 0.3   # poison: make this chrome window MRU
  aerospace workspace 4; sleep 0.3      # retina to 4
  aerospace workspace 1; sleep 0.3      # park focus on terminal (dell, ws1)
  aerospace workspace 7; sleep 0.6      # TRIGGER
  foc=$(aerospace list-workspaces --focused)
  vis=$(aerospace list-workspaces --monitor all --visible | sort -n | tr '\n' ',')
  if [ "$foc" = "7" ] && [ ",$vis" = ",1,4,7," ]; then
    echo "$1: PASS      (focused-ws=$foc visible=[$vis])"
    return 0
  fi
  case ",$vis" in
    *,5,*) echo "$1: FAIL      (5-steal is back! focused-ws=$foc visible=[$vis])"; return 1 ;;
    *)     echo "$1: RESIDUAL  (accepted 2<->7 steal: focused-ws=$foc visible=[$vis])"; return 2 ;;
  esac
}

fails=0
for i in 1 2 3; do
  check "A$i (ws5-MRU)" 5; [ $? -eq 1 ] && fails=$((fails + 1))
done
for i in 1 2 3; do
  check "B$i (ws2-MRU)" 2; [ $? -eq 1 ] && fails=$((fails + 1))
done

# restore the usual layout
aerospace workspace 4 >/dev/null 2>&1
aerospace workspace 1 >/dev/null 2>&1

[ "$fails" -eq 0 ] && echo "OK — the fixed symptom (retina flip to 5) did not reproduce" || echo "$fails REGRESSION(S) — the 5-steal is back"
exit "$fails"
