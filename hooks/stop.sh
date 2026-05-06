#!/bin/bash
# Claude Ops Kit — Stop Hook
# Auto-appends a session entry to the current week's log file on session end.
#
# Reads config from .ops-kit-config (same as session-start.sh).

set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
CONFIG_FILE="$PROJECT_ROOT/.ops-kit-config"

[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"

START_DATE="${OPS_KIT_START_DATE:-$(git log --format="%ai" 2>/dev/null | tail -1 | cut -d' ' -f1 || date +%Y-%m-%d)}"
LOG_DIR="${OPS_KIT_LOG_DIR:-logs/weekly}"

cd "$PROJECT_ROOT" 2>/dev/null || exit 0

TODAY_SEC=$(date +%s)
START_SEC=$(date -d "$START_DATE" +%s 2>/dev/null || gdate -d "$START_DATE" +%s 2>/dev/null || echo "$TODAY_SEC")
DAYS_ELAPSED=$(( (TODAY_SEC - START_SEC) / 86400 ))
WEEK_NUM=$(( DAYS_ELAPSED / 7 ))
WEEK="W${WEEK_NUM}"

LOG_FILE="${LOG_DIR}/${WEEK}.md"
[ -f "$LOG_FILE" ] || exit 0

NOW=$(date '+%Y-%m-%d %H:%M')
LAST_COMMIT=$(git log -1 --pretty=format:'%h %s' 2>/dev/null || echo "no commits")
DIRTY_COUNT=$(git status --porcelain 2>/dev/null | wc -l)
DIRTY_NOTE=""
[ "$DIRTY_COUNT" -gt 0 ] && DIRTY_NOTE=" / uncommitted: ${DIRTY_COUNT} files"

if ! grep -qE "^## Session Log|^## セッションログ" "$LOG_FILE"; then
    printf '\n## Session Log\n\n> Auto-appended by stop hook.\n\n' >> "$LOG_FILE"
fi

echo "- ${NOW} | \`${LAST_COMMIT}\`${DIRTY_NOTE}" >> "$LOG_FILE"
exit 0
