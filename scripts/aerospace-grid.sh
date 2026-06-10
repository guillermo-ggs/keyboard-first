#!/bin/bash
# aerospace-grid.sh — reshape the focused workspace into a 2-row grid.
# Bound to hyper-g in aerospace/aerospace.toml.
#
# How: flatten the workspace tree to one row of columns, force tiles layout,
# then join every 2nd TILING window with its left neighbor. join-with creates
# an opposite-orientation (vertical) container, so each pair becomes a column
# of two: 4 windows -> 2x2, 6 -> 3x2, 5 -> 2+2+1. With <3 tiling windows it
# just flattens (a grid is meaningless).
#
# Floating windows are skipped cleanly: only tiling windows are counted and
# paired, so a float on the workspace no longer skews the pairing (floats
# occupy DFS indices from focus's perspective). Floats are left untouched;
# tile one first (hyper-t) if it should be part of the grid.
set -euo pipefail

# exec-and-forget runs with a minimal env — Homebrew bin is not on PATH there.
export PATH="/opt/homebrew/bin:$PATH"

# flatten-workspace-tree rejects the 'focused' alias (list-windows allows it),
# so resolve the focused workspace's real name first.
ws=$(aerospace list-workspaces --focused)
aerospace flatten-workspace-tree --workspace "$ws"

# Collect the window-ids of tiling (non-floating) windows in DFS order.
# list-windows output order is not documented as DFS order, so don't assume
# it: probe each DFS index with focus --dfs-index (well-defined 0-based DFS,
# floats included per the focus manpage) and ask the focused window for its
# parent-container layout — 'floating' marks a float; h_tiles etc. are tiled.
total=$(aerospace list-windows --workspace "$ws" --count)
tiling=()
i=0
while [ "$i" -lt "$total" ]; do
  aerospace focus --dfs-index "$i"
  read -r id layout < <(aerospace list-windows --focused --format '%{window-id} %{window-layout}')
  if [ "$layout" != "floating" ]; then
    tiling+=("$id")
  fi
  i=$((i + 1))
done

n=${#tiling[@]}
[ "$n" -lt 3 ] && exit 0

# Force tiles on the (now flat) root container, in case it was accordion.
aerospace focus --window-id "${tiling[0]}"
aerospace layout h_tiles

# Pair up: join tiling windows 1, 3, 5, ... with their left neighbor.
k=1
while [ "$k" -lt "$n" ]; do
  aerospace focus --window-id "${tiling[k]}"
  aerospace join-with left || true   # window vanished mid-run: skip, keep going
  k=$((k + 2))
done

# Land focus somewhere predictable: first window.
aerospace focus --window-id "${tiling[0]}"
