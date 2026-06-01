# Case Ledger Template

Use this as the compact record for visible live-browser QA. Keep sensitive data
out of the ledger.

## Test Run Header

- Date / timezone:
- Environment mouth: local dev proxy / shared dev / staging / production / static export
- Branch / commit:
- Backend target:
- Data reset cadence:
- Roles:
- Tenant / campus / site:
- Previous dirty worktree summary:
- This run type: new / supplement / retest / regression / blocker verification

## Case Record

- Case ID:
- Result: PASS / PASS READ-ONLY / PASS UX OBSERVED / PARTIAL / BLOCKED / TIME-GATED / NOT IMPLEMENTED NOT A DEFECT / OBSERVED NEEDS CONFIRMATION / FAIL
- Role and tenant:
- Page path:
- Scenario:
- Steps summary:
- Expected:
- Observed feedback:
- State read-back:
- Cross-role read-back:
- Write executed: yes / no
- Restore result:
- Evidence type: visible browser / API read / code static / docs / user confirmation
- Follow-up:

## Anomaly Confirmation Block

- Observation:
- Why it may be abnormal:
- Business ambiguity:
- User decision:
- Final classification:
- Docs updated:
- Minimum regression after fix:

## Minimum Regression Block

- Triggering issue:
- Preconditions:
- Minimal setup:
- Steps:
- Admin read-back:
- Affected-role read-back:
- Restore:
- Pass criteria:

## Collaboration Handoff Block

- Title:
- Status:
- Code/docs commit:
- Public docs for receiving team:
- Ownership pending: backend contract / frontend fallback / product rule / UX-copy / not implemented
- Items to judge:
- Verification already done:
- What has not been optimized yet:
