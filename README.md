# claude-ops-kit

A minimal Claude Code operations toolkit — hooks, commands, and agents for structured project work.

Built and battle-tested during a 10-week job-hunting sprint using Claude Code as the primary development environment.

## What's Included

| Type | File | Purpose |
|---|---|---|
| Hook | `hooks/session-start.sh` | Display project week / elapsed days / deadline countdown at session start |
| Hook | `hooks/stop.sh` | Auto-append session entry to the current week's log file on exit |
| Command | `commands/weekly-review.md` | Run a structured weekly retrospective and update the log |
| Agent | `agents/job-application-reviewer.md` | Pre-submission review of cover letters and resumes |

## Install

```bash
git clone https://github.com/archforge-labs/claude-ops-kit
cd claude-ops-kit
./install.sh /path/to/your-project
```

Or install into the current directory:

```bash
./install.sh
```

## Configure

Edit `.ops-kit-config` in your project root:

```bash
OPS_KIT_START_DATE="2026-01-01"   # project start (required)
OPS_KIT_TARGET_DATE="2026-07-01"  # deadline (optional)
OPS_KIT_LOG_DIR="logs/weekly"     # weekly log directory
OPS_KIT_PROJECT_NAME="My Project" # display name
```

## Register Hooks

Add to your project's `.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      { "type": "shell", "command": ".claude/hooks/session-start.sh" }
    ],
    "Stop": [
      { "type": "shell", "command": ".claude/hooks/stop.sh" }
    ]
  }
}
```

## Usage

### Session tracking

Once hooks are registered, Claude Code automatically:
- Shows project status when a session starts
- Logs session end time + last commit to `logs/weekly/W{N}.md`

### Weekly review

```
/weekly-review
```

Detects the current week, updates `logs/weekly/W{N}.md` with progress and retrospective prompts.

### Application review

Edit `agents/job-application-reviewer.md` — fill in the `[YOUR_*]` placeholders with your own profile. Then use the agent when reviewing job application documents.

## Weekly Log Structure

Logs are written to `logs/weekly/W{N}.md` where N is the week number since `OPS_KIT_START_DATE`.

```
logs/
└── weekly/
    ├── W0.md
    ├── W1.md
    └── W2.md
```

Each file accumulates session entries automatically via the stop hook:

```
## Session Log

- 2026-05-06 23:30 | `a1b2c3d feat: add feature` / uncommitted: 2 files
```

## Design Principles

- **Zero dependencies** — pure bash hooks, markdown commands
- **Config over hardcode** — all paths and dates in `.ops-kit-config`
- **Non-destructive** — hooks exit cleanly if log files don't exist
- **macOS + Linux** — hooks handle both `date` and `gdate`

## License

MIT
