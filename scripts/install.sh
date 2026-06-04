#!/usr/bin/env bash
# Idempotent bootstrap for the keyboard-first workflow (HANDOFF §7 Phase 0).
# Safe to re-run: skips installed packages, refreshes symlinks, backs up real
# files (non-symlinks) before replacing them.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*"; }

# --- Homebrew ---------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  warn "Homebrew not found — install it first: https://brew.sh"
  exit 1
fi

FORMULAE=(tmux tmuxinator)
CASKS=(nikitabobko/tap/aerospace karabiner-elements raycast)

for f in "${FORMULAE[@]}"; do
  if brew list --formula "$f" >/dev/null 2>&1; then
    info "$f already installed"
  else
    info "installing $f"
    brew install "$f"
  fi
done

for c in "${CASKS[@]}"; do
  name="${c##*/}"   # brew lists casks without the tap prefix
  if brew list --cask "$name" >/dev/null 2>&1; then
    info "$name already installed"
  else
    info "installing $name"
    brew install --cask "$c"
  fi
done

# --- tpm (tmux plugin manager) ----------------------------------------------
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  info "cloning tpm"
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
  info "tpm already present"
fi

# --- Symlinks (decision 8.7: plain symlink script) ---------------------------
link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    ln -sfn "$src" "$dst"
  elif [ -e "$dst" ]; then
    local bak="$dst.bak.$(date +%Y%m%d%H%M%S)"
    warn "backing up existing $dst -> $bak"
    mv "$dst" "$bak"
    ln -s "$src" "$dst"
  else
    ln -s "$src" "$dst"
  fi
  info "linked $dst -> $src"
}

link "$REPO_DIR/tmux/tmux.conf"              "$HOME/.tmux.conf"
link "$REPO_DIR/tmux/tmuxinator/deploy.yml"  "$HOME/.config/tmuxinator/deploy.yml"
link "$REPO_DIR/tmux/tmuxinator/cc.yml"      "$HOME/.config/tmuxinator/cc.yml"
link "$REPO_DIR/aerospace/aerospace.toml"    "$HOME/.config/aerospace/aerospace.toml"
link "$REPO_DIR/karabiner/hyper.json"        "$HOME/.config/karabiner/assets/complex_modifications/hyper.json"

# --- Version pin reminder (AeroSpace is pre-1.0) ------------------------------
AEROSPACE_VERSION="$(brew list --cask --versions aerospace 2>/dev/null || true)"
[ -n "$AEROSPACE_VERSION" ] && info "installed: $AEROSPACE_VERSION (record in README; read release notes before upgrading)"

# --- Manual steps the script cannot do ----------------------------------------
cat <<'EOF'

Manual steps remaining:
  1. AeroSpace : launch it once, grant Accessibility
                 (System Settings > Privacy & Security > Accessibility).
  2. Karabiner : launch Karabiner-Elements, approve its system extension +
                 input-monitoring prompts, then Complex Modifications >
                 Add predefined rule > enable "Caps Lock → Hyper".
  3. tmux      : start tmux, press prefix (Ctrl-Space) + I to install plugins.
  4. Verify    : `aerospace list-apps` and confirm the bundle IDs in
                 aerospace/aerospace.toml match reality.
EOF
