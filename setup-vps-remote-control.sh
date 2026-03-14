#!/usr/bin/env bash
# Setup script for Claude Code remote control on VPS
# Usage: ssh -i ~/.ssh/claw_vps claw@187.124.91.72 'bash -s' < setup-vps-remote-control.sh
# Or copy to VPS and run: bash setup-vps-remote-control.sh

set -euo pipefail

echo "=== VPS Remote Control Setup ==="
echo "Setting up Claude Code for remote server management..."
echo ""

# --- System dependencies ---
echo "[1/5] Updating system packages..."
sudo apt-get update -qq
sudo apt-get install -y -qq curl git build-essential

# --- Node.js (required for Claude Code) ---
echo "[2/5] Installing Node.js (LTS)..."
if ! command -v node &>/dev/null || [[ "$(node -v | cut -d. -f1 | tr -d v)" -lt 18 ]]; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y -qq nodejs
fi
echo "  Node.js version: $(node -v)"
echo "  npm version: $(npm -v)"

# --- Claude Code CLI ---
echo "[3/5] Installing Claude Code CLI..."
npm install -g @anthropic-ai/claude-code

# --- Project directory setup ---
echo "[4/5] Setting up project workspace..."
WORKSPACE="$HOME/workspace"
mkdir -p "$WORKSPACE"

# Clone the website repo if not already present
if [ ! -d "$WORKSPACE/website/.git" ]; then
    echo "  (You can clone your repo into $WORKSPACE later)"
fi

# --- Shell configuration ---
echo "[5/5] Configuring shell environment..."
SHELL_RC="$HOME/.bashrc"

# Add helpful aliases for remote control
if ! grep -q '# Claude Code remote control aliases' "$SHELL_RC" 2>/dev/null; then
    cat >> "$SHELL_RC" << 'ALIASES'

# Claude Code remote control aliases
alias cc='claude'
alias ccc='claude --continue'
alias ccs='claude status'
ALIASES
    echo "  Added shell aliases (cc, ccc, ccs)"
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Set your API key:  export ANTHROPIC_API_KEY='your-key-here'"
echo "     (or add it to ~/.bashrc for persistence)"
echo "  2. Start Claude Code:  claude"
echo "  3. For headless/non-interactive use:  claude -p 'your prompt here'"
echo ""
echo "Quick remote control examples:"
echo "  ssh -i ~/.ssh/claw_vps claw@187.124.91.72 'claude -p \"check disk usage and running services\"'"
echo "  ssh -i ~/.ssh/claw_vps claw@187.124.91.72 -t 'claude'  # interactive session"
echo ""
