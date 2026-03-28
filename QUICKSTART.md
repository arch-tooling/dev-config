# Quick Start - Session Resumption Guide

**Purpose**: How to resume work after interruptions using centralized session management

---

## Basic Session Resumption

### Command

When starting a new Copilot session after interruption:

```
"Resume session for [project-name]"
```

or more explicitly:

```
"Read my 0_NEXT_LATEST.md and recent DONE reports for [project-name]"
```

### What Happens

Copilot will:
1. Read `alex/.copilot-task-state/[project]/0_next/0_NEXT_LATEST.md`
2. Read last 2-3 DONE reports from `alex/.copilot-task-state/[project]/reports/`
3. Summarize:
   - Recent completions
   - Current priorities
   - Open items
   - Active blockers
4. Ask: "What would you like to work on next?"

---

## Project Names

| Project | Command |
|---------|---------|
| GGA Standards | `resume session for gga-standards` |
| Architecture Standards | `resume session for arch-standards` |
| VA | `resume session for VA` |
| GGA R&D | `resume session for gga-standards-rnd` |
| Arch R&D | `resume session for arch-standards-rnd` |
| Copilot GitHub | `resume session for arch-standards-copilot-github` |

---

## Portfolio View (All Projects)

To see activity across ALL projects:

```
"Read 0_NEXT_MASTER.md and summarize my portfolio status"
```

This shows:
- Tasks completed per project
- Last activity dates
- Cross-project priorities
- Recent tasks (last 10 across all projects)

---

## Finding Specific Work

### Last Week's Work

```
"Show me all tasks from last week across all projects"
```

Copilot reads DONE reports, filters by date, summarizes.

### Specific Task Details

```
"Find the DONE report for [task-name] in [project]"
```

Copilot searches `alex/.copilot-task-state/[project]/reports/` for matching filename.

### Files Modified in Task

Every DONE report includes exact file paths in "Deliverables" section.

```
"What files did I modify in task [name]?"
```

---

##Starting New Work

### Multi-Step Tasks (Auto-Tracked)

Just provide your request:

```
"Create architecture documentation for new API integration"
```

Copilot will:
1. Auto-save PROMPT file
2. Execute work in phases  
3. Create DONE report
4. Update Next reports (project + master)

### Simple Queries (Not Tracked)

```
"What's in this file?"
"Format this code"
```

These don't trigger tracking (too trivial).

---

## Checking Progress

### Today's Work

```
"What did I complete today?"
```

Copilot checks DONE reports with today's date across all projects.

### This Week's Work

```
"Summarize my work this week across all projects"
```

Copilot aggregates from Master Next report + recent DONE reports.

### Specific Project Status

```
"What's the status of [project-name]?"
```

Copilot reads project-specific 0_NEXT_LATEST.md.

---

## Typical Workflow

### Morning Start

1. Open VS Code with multi-root workspace (all 6 projects)
2. Decide which project to work on
3. `"Resume session for [project]"`
4. Review summary, pick next task
5. Provide task instructions
6. Copilot saves PROMPT, executes, creates DONE
7. Repeat until end of day

### After Interruption

1. `"Resume session for [project]"`
2. Copilot reminds you what you were doing
3. `"Continue with [specific task]"` or choose new work

### End of Week

1. `"Read 0_NEXT_MASTER.md and summarize this week's accomplishments"`
2. Review portfolio status
3. Plan next week's priorities

---

## Tips

**Be Specific with Project Names**:
- ✅ "Resume gga-standards"
- ❌ "Resume work" (unclear which project)

**Use Explicit Commands When Unsure**:
- ✅ "Read my 0_NEXT_LATEST.md for VA"
- Instead of relying on implicit resume

**Check Master Report Weekly**:
- Provides cross-project visibility
- Identifies dependencies
- Highlights blockers affecting multiple projects

**Reference PROMPT Files for Context**:
- If resuming complex task, ask Copilot to read the PROMPT file
- `"Read PROMPT_20260327_1120.md for context"`

---

## Troubleshooting

**Copilot doesn't remember previous work**:
- Explicitly say: `"Read 0_NEXT_LATEST.md for [project]"`
- Check that DONE reports exist in `alex/.copilot-task-state/[project]/reports/`

**Unsure which project you were working on**:
- `"Read 0_NEXT_MASTER.md and show me what was worked on most recently"`

**Can't find a specific task**:
- `"List all DONE reports for [project] from this month"`
- Copilot will scan reports directory

---

**Quick Reference Card**: Print and keep handy

```
RESUME:    "Resume session for [project]"
PORTFOLIO: "Read 0_NEXT_MASTER.md"
TODAY:     "What did I complete today?"
FIND:      "Find DONE report for [task] in [project]"
STATUS:    "What's the status of [project]?"
```

---

**Last Updated**: 2026-03-27
