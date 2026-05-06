---
description: Generate or update the current week's review log with progress summary and retrospective.
---

# /weekly-review

Run a structured weekly retrospective and update the current week's log file.

## Behavior

1. **Determine current week number**
   - Calculate W0, W1, W2... from `OPS_KIT_START_DATE` in `.ops-kit-config`
   - Falls back to git log date if not configured

2. **Locate or create the log file**
   - Target: `logs/weekly/W{N}.md`
   - If the file exists: update it
   - If not: generate from template

3. **Auto-collect and populate**
   - Git log: commit count and changed files this week
   - Previous week's `## Next Week` section (if present)
   - Current date and week number

4. **Prompt the user to fill in**
   - KPT retrospective (Keep / Problem / Try)
   - Energy/burnout indicators (1–5 scale)
   - Actual time spent per block

5. **Output a weekly summary table**
   - Goals vs. actuals
   - Top 3 priorities for next week
   - Risk flags (if burnout score ≥ 4 on 2+ items)

## Output Format

Write/Edit `logs/weekly/W{N}.md` with:

- Week theme
- Commitments checklist (done / not done)
- Progress summary table
- KPT retrospective (user fills in)
- Next week's top 3 priorities
- Time usage table
- Burnout indicators

## Usage

```
/weekly-review
```

Automatically detects the current week and opens the appropriate log file.

## Convention

- Run every Sunday evening
- If KPT is left blank for 3 consecutive weeks → revisit the workflow
- Burnout ≥ 4 on 2+ items → add a warning note and consider reducing scope

## Related Files

- `logs/weekly/` — weekly log directory
- `.ops-kit-config` — project start date and configuration
