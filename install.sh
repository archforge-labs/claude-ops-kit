#!/bin/bash
# Claude Ops Kit — Install Script
# Copies hooks, commands, and agents into the target project's .claude/ directory.
#
# Usage:
#   ./install.sh               # install into current directory
#   ./install.sh /path/to/proj # install into specific project

set -euo pipefail

TARGET="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing Claude Ops Kit into: $TARGET"

# Create directories
mkdir -p "$TARGET/.claude/hooks"
mkdir -p "$TARGET/.claude/commands"
mkdir -p "$TARGET/.claude/agents"

# Copy hooks
cp "$SCRIPT_DIR/hooks/session-start.sh" "$TARGET/.claude/hooks/"
cp "$SCRIPT_DIR/hooks/stop.sh"          "$TARGET/.claude/hooks/"
chmod +x "$TARGET/.claude/hooks/session-start.sh"
chmod +x "$TARGET/.claude/hooks/stop.sh"

# Copy commands
cp "$SCRIPT_DIR/commands/weekly-review.md" "$TARGET/.claude/commands/"

# Copy agents
cp "$SCRIPT_DIR/agents/job-application-reviewer.md" "$TARGET/.claude/agents/"

# Copy config example (don't overwrite existing config)
if [ ! -f "$TARGET/.ops-kit-config" ]; then
    cp "$SCRIPT_DIR/.ops-kit-config.example" "$TARGET/.ops-kit-config"
    echo ""
    echo "Created .ops-kit-config — edit it to set your project dates."
else
    echo ".ops-kit-config already exists — skipped."
fi

echo ""
echo "Done. Next steps:"
echo "  1. Edit .ops-kit-config (set OPS_KIT_START_DATE)"
echo "  2. Register hooks in .claude/settings.json:"
echo '     { "hooks": { "SessionStart": [{"type":"shell","command":".claude/hooks/session-start.sh"}], "Stop": [{"type":"shell","command":".claude/hooks/stop.sh"}] } }'
echo "  3. Edit agents/job-application-reviewer.md — fill in [YOUR_*] placeholders"
echo "  4. Create logs/weekly/ directory for weekly review logs"
