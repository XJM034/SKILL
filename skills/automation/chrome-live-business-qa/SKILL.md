---
name: chrome-live-business-qa
description: >
  Use when running visible Chrome QA for a live or shared-dev business app with
  multiple roles, real backend state, write flows, exports, and cross-role
  side effects. Captures full-flow testing, evidence discipline, stop rules,
  restoration, and handoff/collaboration docs.
metadata:
  author: innei
  version: "0.1.0"
---

# chrome-live-business-qa

Run visible browser QA as a real user would use the product, while keeping live
data recoverable and evidence useful for the next agent. The skill is built for
multi-role systems where an admin action changes a teacher, staff, customer, or
operator view.

## When to Use

Use this when:

- The user asks for end-to-end visible QA before launch or internal testing.
- The app has role-separated flows.
- The test uses real or shared-dev backend data, not a disposable mock DB.
- The work includes write flows, exports, copy-to-clipboard, login/session
  boundaries, or product/UX observations.
- The user expects reusable QA documentation, not just a pass/fail chat reply.

## Inputs

- App URLs for each role. Prefer different hosts for cookie isolation, for
  example `localhost` for admin and `127.0.0.1` for teacher.
- Test role accounts from the project's approved local account selector or
  credential source. Never write secrets, phone numbers, or verification codes
  into public docs.
- Current environment mouth: local dev proxy, shared dev, staging, production,
  or static export. Keep these separate.
- Known reset cadence for backend data.
- Existing QA docs, backend-collaboration docs, and latest handoff.

## Files Provided

`references/case-ledger-template.md` has compact QA and handoff templates.

## Workflow

```text
[1] Lock context and safety boundary
[2] Open visible role-isolated sessions
[3] Test scenarios as real workflows
[4] Verify every side effect in the affected role
[5] Classify observations and ask for confirmation
[6] Restore writes and record leftovers
[7] Run stop/over-test audit
[8] Publish docs and collaboration handoff
```

## 1. Lock Context and Safety Boundary

Start by writing down the exact test scope:

- Date, timezone, campus/tenant/site, environment, branch, and backend target.
- Role accounts used, without sensitive identifiers.
- Whether this is new coverage, supplement, regression, or blocker retest.
- Expected data reset behavior. If data resets daily, reacquire current valid
  accounts and course/order/task samples after the date changes.
- Current worktree state:

```bash
git status --porcelain=v1 --branch
```

If the repository has many unrelated dirty files, do not clean them. Note that
they pre-exist and keep QA docs scoped to the current run.

## 2. Open Visible Role-Isolated Sessions

Use a real visible browser when the user needs to see the flow.

- Keep one tab/profile for admin and another for the affected role.
- Prefer host isolation to avoid cookie collisions, such as:
  - admin: `http://localhost:3000`
  - teacher/user: `http://127.0.0.1:3000`
- If the user has already logged in, reuse the existing tabs.
- If a session drops to login, null, empty state, or stale tenant data, stop
  business judgment until the session is restored or the user confirms it as an
  anomaly.

## 3. Test Scenarios as Real Workflows

Do not mark a feature done because the page opened.

For each feature, cover:

- Entry point and prerequisites.
- Empty and partial form validation.
- Search hit, empty result, clear/reset, pagination, return path.
- Confirmation dialogs, cancel/close branches, and destructive-action guardrails.
- Save/submit branch if authorized.
- List/detail/home read-back after save.
- Export/copy visible feedback and content structure.
- Recovery or restoration path.

Treat operation logic as part of QA. Missing confirmations, misleading labels,
non-semantic clickable text, unclear disabled states, and no feedback after copy
belong in the ledger even if the backend state is correct.

## 4. Verify Cross-Role Side Effects

Admin success is not the end of the test.

Whenever a write can affect another role, switch tabs immediately and verify the
affected role:

- Time changes: class time, attendance window, calendar/week schedule.
- Teacher changes: substitute teacher, restore default, swap, merge/group.
- Student or roster changes: admin-added, user-added, source labels.
- Attendance changes: detail page, overview, unarrived/exception list, export.
- Session changes: logout, expired token, role mismatch, protected routes.

If the second role is time-gated, record `TIME-GATED`. If the user changes data
manually during the run, record it and re-lock the sample.

## 5. Classify and Confirm Observations

Use explicit labels:

- `PASS` - evidence shows the workflow works as expected.
- `PASS / READ-ONLY` - read or cancel path verified, no write executed.
- `PASS / UX OBSERVED` - function works, but operation logic can improve.
- `PARTIAL` - only part of the workflow was covered.
- `BLOCKED` - time, permissions, backend, unrecoverable data, or tool limits.
- `TIME-GATED` - real business time window prevents equivalent retest.
- `NOT IMPLEMENTED / NOT A DEFECT` - user confirms an exposed/expected gap is
  not built yet.
- `OBSERVED / NEEDS CONFIRMATION` - suspicious but business rule is unknown.
- `FAIL` - confirmed anomaly, data inconsistency, permission break, or risk.

Stop on a suspicious write-path anomaly and ask the user before upgrading it.
If confirmed, promote it to `FAIL` and update docs. If rejected, keep the
observation with the user's rule.

## 6. Restore Writes and Record Leftovers

Before every live write, know how to undo it.

After the write:

- Read back affected pages.
- Restore default teacher, time, status, grouping, or test data.
- Re-read admin and affected role.
- If restore fails, record `BLOCKED`, the remaining live data, and the exact
  cleanup path needed.

Never keep testing on top of dirty business data without naming the risk.

## 7. Export, Copy, and Text Output Checks

Exports are user-facing product surface.

For text export/copy:

- Compare greeting, hierarchy, separators, grouping, location fields, and item
  aggregation against the promised template.
- Read clipboard content when the tool allows it. If not, record the limitation.
- Check for sensitive data leakage patterns.
- Summarize structure and counts. Do not paste full real lists into public docs.
- Verify visible success feedback matches the actual export semantics.

## 8. Stop and Over-Test Audit

Long live QA must have a stop rule.

Pause and audit when:

- The run has lasted for hours.
- Core create/edit/time/teacher/group/status/export/login/navigation flows have
  evidence.
- Further testing would repeat writes or increase live data risk.
- Remaining work is better expressed as minimum regression after fixes.

Close the full-flow phase with:

- Covered surface.
- Confirmed failures and blockers.
- Accepted non-defects.
- Product/UX follow-ups.
- Minimum regression set.
- Explicit "do not repeat full live write flow" boundary.

## 9. Documentation and Collaboration Handoff

Update durable docs before calling the run done:

- Quality report with case outcomes and evidence type.
- Quality README/history index.
- Regression checklist with the minimum retest set.
- Backend or cross-team collaboration issue list.
- External collaboration table if the project uses one.

Collaboration records must include all pending optimization items, not only
backend bugs. Say whether frontend code has already been optimized. If not, ask
the receiver to classify ownership: backend contract, frontend fallback/copy,
product rule, or direct frontend patch.

## Common Pitfalls

| Mistake | Fix |
| ------- | --- |
| Clicking pages instead of testing workflows | For every feature, verify entry, action, feedback, state change, read-back, and return path. |
| Treating admin save as complete | Immediately verify the affected role when admin writes can change another role. |
| Using yesterday's samples after backend reset | Reacquire current-day accounts and live samples before continuing. |
| Recording full phone numbers or real lists | Record role, tenant, counts, IDs when allowed, and structure summaries only. |
| Continuing after a null/session failure | Stop business judgment, restore login, or classify as session/error-boundary anomaly. |
| Repeating live writes after coverage is enough | Run a stop audit and switch to minimum regression. |
| Calling an unimplemented feature a defect | Ask the user; if confirmed not built, mark `NOT IMPLEMENTED / NOT A DEFECT`. |
| Blaming product for proxy/network stalls | Separate local proxy/VPN/tool limits from product behavior, then retest in the right mode. |
| Forgetting restore evidence | Record both write and restore read-backs, or leave a `BLOCKED` cleanup item. |
| Syncing only backend bugs to collaboration docs | Sync backend, frontend, product, UX, copy, and not-yet-built items with ownership pending. |

## Rules for the Next Agent

- Read the latest handoff, QA closeout, regression checklist, and collaboration
  issue list before opening the browser.
- Use approved account selectors or user-provided sessions; do not invent
  credentials.
- Keep role tabs isolated and preserve logged-in sessions when the user already
  prepared them.
- Do not modify business code during a QA-only run.
- Do not create mocks or local fixtures to pretend backend behavior is connected.
- When a write affects another role, test both roles before moving on.
- Ask before upgrading ambiguous behavior to `FAIL`.
- Keep public reports free of phone numbers, codes, secrets, and full real lists.
- Push/share only allowed docs; keep local testing rules and raw artifacts local
  unless explicitly approved.

## Verification Checklist

- [ ] Context, environment, branch, role, and reset cadence recorded.
- [ ] `git status --porcelain=v1 --branch` captured before and after.
- [ ] Each tested feature has action, feedback, read-back, and return-path notes.
- [ ] Cross-role side effects were verified or labeled `TIME-GATED` / `BLOCKED`.
- [ ] Suspicious behavior has user confirmation or `OBSERVED / NEEDS CONFIRMATION`.
- [ ] Live writes were restored or documented as leftover cleanup.
- [ ] Export/copy tests include structure, feedback, and sensitive-data checks.
- [ ] Stop audit completed before ending a long run.
- [ ] Quality, regression, and collaboration docs updated.
- [ ] Collaboration handoff includes all ownership-pending items.
