#!/usr/bin/env bash
# Claude Ops Kit — PreToolUse Hook: pre-edit-guard
# Warns before Claude edits sensitive files (secrets, migrations, configs).
#
# Register in .claude/settings.json:
#   "PreToolUse": [{ "type": "shell", "command": ".claude/hooks/pre-edit-guard.sh" }]
#
# Customize SENSITIVE_PATTERNS below to match your project.

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | python3 -c "
import json, sys
data = json.load(sys.stdin)
print(data.get('tool_input', {}).get('file_path', ''))
" 2>/dev/null)

[ -z "$FILE_PATH" ] && exit 0

# Add or remove patterns to suit your project
SENSITIVE_PATTERNS="\.env$|\.env\.|schema\.sql|/migrations?/|secrets|credentials|\.pem$|\.key$|settings\.local"

if echo "$FILE_PATH" | grep -qE "$SENSITIVE_PATTERNS"; then
    echo "⚠️  Sensitive file detected: $(basename "$FILE_PATH")"
    echo "   Path: $FILE_PATH"
    echo "   Verify this edit is intentional."
fi

exit 0
