#!/bin/bash
# Claude Ops Kit — SessionStart Hook
# Displays project status at the start of each Claude Code session.
#
# Configuration: create .ops-kit-config in your project root
#
#   OPS_KIT_START_DATE="YYYY-MM-DD"   # project start date
#   OPS_KIT_TARGET_DATE="YYYY-MM-DD"  # goal date (optional)
#   OPS_KIT_LOG_DIR="logs/weekly"     # path to weekly logs (default: logs/weekly)
#   OPS_KIT_PROJECT_NAME="My Project" # display name (default: repo name)

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
CONFIG_FILE="$PROJECT_ROOT/.ops-kit-config"

[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"

# Defaults
START_DATE="${OPS_KIT_START_DATE:-$(git log --format="%ai" 2>/dev/null | tail -1 | cut -d' ' -f1 || date +%Y-%m-%d)}"
TARGET_DATE="${OPS_KIT_TARGET_DATE:-}"
LOG_DIR="${OPS_KIT_LOG_DIR:-logs/weekly}"
PROJECT_NAME="${OPS_KIT_PROJECT_NAME:-$(basename "$PROJECT_ROOT")}"

TODAY_SEC=$(date +%s)
START_SEC=$(date -d "$START_DATE" +%s 2>/dev/null || gdate -d "$START_DATE" +%s 2>/dev/null || echo "$TODAY_SEC")
DAYS_ELAPSED=$(( (TODAY_SEC - START_SEC) / 86400 ))

WEEK_NUM=$(( DAYS_ELAPSED / 7 ))
WEEK="W${WEEK_NUM}"
[ "$DAYS_ELAPSED" -lt 0 ] && WEEK="Pre-start"

DAYS_UNTIL_ROW=""
if [ -n "$TARGET_DATE" ]; then
    TARGET_SEC=$(date -d "$TARGET_DATE" +%s 2>/dev/null || gdate -d "$TARGET_DATE" +%s 2>/dev/null || echo "$TODAY_SEC")
    DAYS_UNTIL=$(( (TARGET_SEC - TODAY_SEC) / 86400 ))
    DAYS_UNTIL_ROW="| Days until ${TARGET_DATE} | **${DAYS_UNTIL}** |"
fi

cat <<EOF
# 📅 ${PROJECT_NAME}

| | |
|---|---|
| Week | **${WEEK}** |
| Elapsed | ${DAYS_ELAPSED} days |
${DAYS_UNTIL_ROW}

Log: ${LOG_DIR}/${WEEK}.md
EOF
