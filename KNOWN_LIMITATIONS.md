# Known Limitations

**Purpose**: Document known issues, limitations, and workarounds for centralized session management system

**Last Updated**: 2026-03-27

---

## 1. Session Collision Risk

### Issue

**Single user working across multiple projects simultaneously** could create conflicting instructions.

**Scenario**:
1. Open Copilot session in gga-standards (Session A)
2. Start task, Copilot saves PROMPT
3. Open second Copilot session in VA (Session B) without closing Session A
4. Start different task with conflicting instructions
5. Both sessions try to update files simultaneously

**Impact**: Medium (file conflicts, confusion about which task is active)

**Likelihood**: Low (requires intentional parallel sessions)

**Current Mitigation**:
- Timestamp-based filenames prevent file overwrites
  - PROMPT/DONE files use minute-level timestamps
  - Collision only if starting tasks in same minute
- Project scoping prevents cross-project conflicts
  - gga-standards tasks write to gga-standards/ subdirectory
  - VA tasks write to VA/ subdirectory

**Acceptance**: Accepted temporarily for single-user, single-PC scenario

**Monitoring**: Track collision frequency over first month

**Trigger for Re-Architecture**: If >2 collisions per week, implement:
- Session ID in PROMPT/DONE files
- Lock file mechanism in `.copilot-task-state/`
- Active session registry

**Workaround**:
- Close previous Copilot session before starting new one in different project
- Or finish task in Session A before starting Session B
- Check file timestamps if collision suspected

---

## 2. Multi-Root Workspace Detection

### Issue

GitHub Copilot may not reliably detect alex/.github/copilot-instructions.md when workspace is multi-root.

**Current Implementation**: Minimal include pattern (fallback)
- Each workspace has `.github/copilot-instructions.md`
- References alex/.github/ for actual standards
- Ensures auto-load works regardless of VS Code behavior

**Tested**: Option 3 (no workspace .github/) **not tested** - assumed risky

**Risk If Option 3 Used**:
- Copilot might not find alex standards when editing files in gga-standards
- Standards not enforced
- Inconsistent behavior across workspaces

**Mitigation**: Using minimal include pattern in all 6 workspaces

**Future Test**: After validation period, try Option 3 in one workspace, verify auto-load

---

## 3. Manual Master Report Updates

### Issue

Master portfolio report (0_NEXT_MASTER.md) **auto-updates** after every task completion.

**Potential Problem**: If Copilot fails to update Master after task, portfolio view becomes stale.

**Current Design**: Auto-update enabled (low overhead, <1 second)

**Fallback**: Manual comprehensive update command:
```
"Update master portfolio report comprehensively"
```

**Monitoring**: Check Master report after each task completion, ensure stats accurate

**If Auto-Update Fails**:
- Use manual command
- Report issue for investigation
- Temporary workaround: Read all project Next reports manually

---

## 4. VA Backup Retention

### Issue

VA history backup exists at `C:\Users\alk\src\VA-bk-20260327\` until **2026-04-10** (2 weeks).

**Purpose**: Safety net if migration issues discovered

**Risk**: Forgetting to delete backup after retention period

**Reminder Schedule**:
- **2026-04-03** (1 week): Review backup, verify migration successful
- **2026-04-10** (2 weeks): Delete backup if no issues

**Validation**: Compare migrated files in alex/.copilot-task-state/VA/ with backup

**If Issues Found Before 2026-04-10**:
- Restore from backup
- Investigate migration problems
- Re-migrate with fixes

---

## 5. No Cross-Platform Support

### Limitation

System designed for **single user, single PC** (Windows).

**Paths are absolute**:
- `C:\Users\alk\src\alex\...`
- Not portable to other machines or users

**If Sharing With Team**:
- Would need relative paths in copilot-instructions.md
- Would need user-specific task-state directories
- Would need merge conflict resolution for concurrent DONE reports

**Current Scope**: Personal use only (Alex, one PC)

**Future Enhancement**: Design multi-user architecture if team adoption needed

---

## 6. No Automated Cleanup

### Issue

PROMPT/DONE/Next files accumulate indefinitely.

**Archive Strategy**: Per-project Next reports archive old versions:
- `0_next/archive/0_NEXT_YYYYMMDD-HHmm.md`

**No Archive for**: PROMPT, DONE reports

**Potential Growth**:
- 50 tasks/month × 12 months = 600 PROMPT files/year
- 600 DONE files/year
- Each ~2-5 KB = ~3-6 MB/year per project
- All 6 projects: ~20-40 MB/year

**Acceptable**: Years before cleanup needed

**Future Cleanup** (when >500 files per project):
- Archive older than 6 months
- Move to `archive-YYYY/` subdirectories
- Keep searchable but out of main reports/

---

## 7. UTF-8 Encoding Verification

### Issue

System assumes all files created with UTF-8.

**Potential Problem**: If Copilot or manual edits introduce non-UTF-8 encoding

**Current Mitigation**:
- Global standard enforces UTF-8
- Verification checklist in copilot-instructions.md
- Validation tested encoding correctness

**If Encoding Issues Occur**:
```powershell
# Check file encoding
Get-Content file.md -Encoding UTF8 -ErrorAction Stop

# Fix encoding
Get-Content file.md | Set-Content file.md -Encoding UTF8
```

**Prevention**: Always use VS Code (defaults to UTF-8)

---

## 8. Fact Verification Not Required for Trivial Tasks

### Clarification

Fact verification tags (✅📝⚠️🔮❌❓) are **not required** for:
- Validation tasks
- Simple file operations
- Trivial documentation updates

**Only required for**: Technical documentation making factual claims

**Example**:
- ✅ Validation task README update: No fact verification needed
- ❌ Architecture document with performance claims: Fact verification required

**Guideline**: If task involves claims about system behavior, performance, architecture → verify facts

---

## 9. No GUI Dashboard

### Current State

All status tracking via markdown files (0_NEXT_LATEST.md, 0_NEXT_MASTER.md).

**Limitation**:
- No visual charts/graphs
- No real-time updates
- No web interface

**Workaround**: Read markdown files directly (human-readable)

**Future Enhancement**:
- Web dashboard for portfolio visualization
- Charts: tasks over time, time per project, velocity trends
- Real-time updates via file watching

**Defer**: Not critical for single-user scenario

---

## 10. Session Resumption Relies on Explicit Command

### Current Behavior

Copilot **does not automatically** load project context when session starts.

**User must say**: `"Resume session for [project]"`

**Potential Enhancement**: Auto-resume on first message in session
- Detect current workspace
- Auto-read 0_NEXT_LATEST.md
- Provide status summary unsolicited

**Current Design**: Explicit command required (prevents unwanted overhead)

**Workaround**: Make `"Resume session"` a habit at session start

---

## Escalation Path

**If you encounter an issue not listed here**:

1. Check [Validation Summary](.copilot-task-state/VALIDATION_SUMMARY.md) - Maybe already known
2. Search DONE reports - Maybe documented in previous task
3. Ask Copilot: `"Is there a workaround for [issue]?"`
4. Document in this file for future reference

---

## Accepted Limitations Summary

| Limitation | Impact | Acceptance | Monitor |
|------------|--------|------------|---------|
| Session collision | Medium | Accepted | Track frequency |
| Multi-root detection | Low | Mitigated (fallback) | N/A |
| Manual Master update | Low | Auto-update mitigates | Check after tasks |
| VA backup retention | Low | Reminder set | Delete 2026-04-10 |
| Single PC only | N/A | By design | N/A |
| No automated cleanup | Low | Acceptable growth | Revisit at 500+ files |
| UTF-8 verification | Low | Standards enforce | Ad-hoc checks |
| Fact verification scope | N/A | Documented | N/A |
| No GUI dash | Low | Markdown sufficient | Future enhancement |
| Manual resume | Low | Acceptable | N/A |

---

**Last Updated**: 2026-03-27  
**Next Review**: 2026-04-27 (after 1 month of use)
