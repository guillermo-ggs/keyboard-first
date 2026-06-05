#!/bin/bash
# aerospace-grid.sh — reshape the focused workspace into a 2-row grid.
# Bound to hyper-g in aerospace/aerospace.toml.
#
# How: flatten the workspace tree to one row of columns, force tiles layout,
# then join every 2nd window (DFS indices 1, 3, 5, ...) with its left
# neighbor. join-with creates an opposite-orientation (vertical) container,
# so each pair becomes a column of two: 4 windows -> 2x2, 6 -> 3x2,
# 5 -> 2+2+1. With <3 windows it just flattens (a grid is meaningless).
#
# Limitation: floating windows on the workspace are skipped by join-with;
# tile them first (hyper-t) if they should be part of the grid.
set -euo pipefail

# exec-and-forget runs with a minimal env — Homebrew bin is not on PATH there.
export PATH="/opt/homebrew/bin:$PATH"

# flatten-workspace-tree rejects the 'focused' alias (list-windows allows it),
# so resolve the focused workspace's real name first.
ws=$(aerospace list-workspaces --focused)
aerospace flatten-workspace-tree --workspace "$ws"

n=$(aerospace list-windows --workspace "$ws" --count)
[ "$n" -lt 3 ] && exit 0

# Force tiles on the (now flat) root container, in case it was accordion.
aerospace focus --dfs-index 0
aerospace layout h_tiles

i=1
while [ "$i" -lt "$n" ]; do
  aerospace focus --dfs-index "$i"
  aerospace join-with left || true   # floating window: skip, keep going
  i=$((i + 2))
done

# Land focus somewhere predictable: first window.
aerospace focus --dfs-index 0
