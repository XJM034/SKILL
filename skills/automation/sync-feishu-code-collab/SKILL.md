---
name: sync-feishu-code-collab
description: Use when submitting, updating, or drafting Feishu/Lark Base code-collaboration records or maintaining the linked product task board for frontend/backend coordination. Covers push records, commits, MRs, deployments, backend handoff docs, style screenshots, user feedback intake, task boards, bug/optimization/refactor/new-requirement backlogs, PM progress dashboards, task evidence attachments, and test-case source tracking. Triggers include "补充协同相关信息", "同步到飞书协同表", "补推送记录", "前后端协作文档", "页面修改截图", "用户反馈录入", "反馈入板", "任务看板", "Bug 池", "待优化", "PM 进度总览", "测试用例来源", and "用 lark-cli 补一条记录".
---

# Sync Feishu Code Collab

## Current Scope

Use this skill as a frontend-led collaboration workflow by default. It is tuned for two related Feishu/Base surfaces:

- Push ledger mode: frontend commits, push records, MRs, deployments, backend-facing docs, UI/copy/interaction screenshots, and frontend repos that publish backend-visible review material.
- Task board mode: product-quality backlog items such as bugs, optimizations, refactors, new requirements, PM progress dashboards, issue evidence attachments, and future test-case source tracking.

Backend teams can reuse the workflow, but they must configure their own repo-visible collaboration docs, Base field mapping, verification commands, attachment policy, task taxonomy, and `lark-cli` auth/scopes before performing external writes.

## Inputs

- Target repo or current working directory.
- Requested mode: push ledger, task board, dashboard/view maintenance, attachment sync, or draft-only.
- Commit, branch, MR, deployment, record id, task id, dashboard id, view id, or enough context to identify the latest relevant change.
- User feedback package, problem description, screenshots/videos, bug list, optimization/refactor/new-requirement list, or PM-dashboard request when working in task board mode.
- Project-local Feishu/Base collaboration docs, or a table link/config supplied by the user.
- Verification results that were actually run.
- Screenshot or evidence batch path only when visual/task evidence is needed.

## Files Provided

- `references/feishu-code-collab-requirements.md`: detailed project discovery, `lark-cli` baseline setup, field mapping, task board rules, dashboard/view rules, screenshot/evidence policy, push/privacy boundaries, and final report checklist.

## Core Rule

Treat the Feishu/Base as a collaboration surface, not as the only source of truth.

- Push records are the collaboration ledger for code changes, handoff docs, verification scope, and optional style screenshots.
- Task board records are the product-quality backlog and the future source pool for test-case design.
- Interface issues, field contracts, permissions, stability problems, detailed test results, and backend action items must still live in the target project's repo-local collaboration docs before they are referenced in Feishu.

Do not write product backlog tasks into the push-record table unless the project explicitly uses one table for both workflows. Do not treat the task board as a replacement for repo docs when a counterpart needs durable technical evidence.

Do not hard-code Base tokens, table IDs, view IDs, dashboard IDs, field IDs, people IDs, or project-specific paths from memory. Read them from the current project's protected docs or from explicit user input.

Confirm `lark-cli` is installed, configured, and authenticated before writing. If the CLI, Base schema, or permission scopes are missing, stop at that boundary instead of guessing field structure or writing partial records.

## Quick Workflow

```text
[1] Find project rules and current Feishu/Base surfaces
[2] Decide whether this is push ledger mode or task board mode
[3] Identify branch/commit/MR/record/task/view/dashboard target
[4] Confirm repo-visible counterpart docs when technical handoff is involved
[5] Verify lark-cli auth and Base schema
[6] Create or update records, views, dashboards, or attachments
[7] Read back and report exact evidence
```

1. Establish the target project.
   - Use the current working directory when it is clearly the requested repo.
   - Read project instructions first, especially `AGENTS.md`, `CLAUDE.md`, latest handoff, tooling docs, and any document matching `飞书`, `Base`, `协同`, `推送记录`, `前后端`, `任务看板`, `Bug`, `测试用例`.
   - First guide the user toward the current project's existing Feishu/Base collaboration table when local docs identify one.
   - If the current table link or Base identifiers cannot be found and the user wants an external write, stop and ask the user to get the table link from the project owner or create/provide their own Feishu/Base table link plus required field policy before writing.

2. Identify the work mode and target.
   - Push ledger mode: prefer a user-specified branch, commit, MR, deployment, or record id; otherwise inspect the current branch, recent commits, and dirty worktree.
   - Task board mode: prefer a user-specified task id, view, dashboard, table, backlog list, or user feedback package; otherwise read the existing task board schema before creating or reshaping fields.
   - Do not overwrite or clean unrelated user changes.

3. Prepare repo-visible handoff material.
   - For backend-facing issues, confirm the project has Codeup/Git-visible docs for backend review.
   - Reference only documents that the counterpart can actually see.
   - If there are no new backend-facing documents, write that explicitly in the collaboration note instead of leaving it blank.

4. Verify the Feishu/Base schema.
   - Use `lark-cli` with `--as user`.
   - Read `references/feishu-code-collab-requirements.md#lark-cli-baseline-configuration` before the first write in a repo or machine.
   - Search or read the Base/table/fields/views/dashboards before writing unless the user gave a current record id and schema.
   - If `lark-cli` reports missing scopes, auth login, or quota/permission issues, pause external writes and report the authorization boundary.

5. Create or update push records.
   - Draft field values from commit evidence plus verified project docs.
   - Do not invent push links, MR links, verification results, or owners.
   - Record the verification scope precisely: unit/lint/build, local dev, shared dev, static export, staging, internal test, or production are separate evidence classes.

6. Create or update task board records.
   - When the user gives a direct feedback package such as problem description plus screenshots, treat it as task board intake by default. Extract the symptom, affected role/page/device/campus, expected result, evidence, suspected priority, and missing confirmation points.
   - Structure user feedback into task fields instead of pasting raw notes: concise title, type, status, priority, owner, impacted side, target campus/scope, phenomenon, expected result, reproduction/evidence, acceptance criteria, blockers, test-case status, and release gate.
   - Use the project-configured owner options and default owner. If local project docs say the active owners are `kt` and `alex` with a default owner, follow that; otherwise do not invent people.
   - Use a campus/scope field for campuses such as pilot or future rollout sites; do not create one table per campus unless the project explicitly asks for that.
   - Keep active development views free of closed tasks and blank records. A development kanban grouped by priority should filter out closed records and require a non-empty task id.
   - Closed bugs may stay in the task board for regression history, but they should not clutter the active development flow.
   - Future test cases should derive from confirmed bug tasks in the task board rather than from free-floating text.

7. Maintain dashboards and views carefully.
   - PM overview dashboards should summarize total tasks, active P0/P1 risk, status distribution, priority distribution, type distribution, and test-case readiness when those fields exist.
   - Verify dashboard blocks with read-back data after creation. Do not leave broken or experimental blocks in the user's Base.
   - For grouped dashboard charts, use the `group_by` data configuration shape documented in the reference file, not ad hoc `dimension` or `dimensions` keys.

8. Handle screenshots and task evidence conservatively.
   - Screenshots and attachments are local by default. Upload external attachments only when the user explicitly asks to upload/sync them.
   - For push ledger screenshots, follow the project style-screenshot policy.
   - For task board evidence, use the task board's evidence attachment field when configured. Do not reuse a push-record frontend screenshot field as the task evidence field unless the project says they are the same field.
   - If live data cannot show the target state yet, mark it as a frontend target-state preview and explain why live/current state is not the source of truth.
   - If temporary fixture data is needed, keep it outside the repo and clean it after user approval. Never add repo mocks or runtime fallback data just to make a screenshot.

9. Read back and report.
   - After writing, read the Feishu record/view/dashboard back and confirm key fields, filters, grouping, charts, and attachments.
   - Summarize the record id/number or task count, branch, commit SHA, docs referenced, screenshot/evidence upload status, and any remaining authorization or validation gaps.

## What To Load

Read `references/feishu-code-collab-requirements.md` when performing a real sync, drafting field values, working on task boards, maintaining views/dashboards, dealing with screenshots/evidence attachments, or deciding whether a document/asset may be pushed or uploaded.

## Safety Boundaries

- Do not place Base identifiers from a protected project doc into public docs, PR text, or generic skill updates.
- Do not upload screenshots or attachments unless the user explicitly requested external upload.
- Do not write task backlog items into the push ledger unless the project explicitly uses one table for both workflows.
- Do not create campus-specific task tables when a campus/scope field can express rollout scope.
- Do not use local-only agent rules, raw test artifacts, screenshot folders, browser traces, or private account caches as backend-visible evidence unless the project explicitly allows it.
- Do not treat a Feishu record as proof that a backend issue is documented; the repo-local collaboration doc remains the durable technical handoff.
- Do not leave blank auto-created records visible in development kanbans; delete blanks when safe and add a non-empty task-id filter.
- Do not claim "already pushed", "already deployed", "backend aligned", "test cases covered", or "live verified" without current evidence.

## Common Pitfalls

| Mistake | Fix |
| ------- | --- |
| Treating Feishu as the source of truth | Write durable technical evidence in repo-local collaboration docs first, then reference those docs in Feishu. |
| Creating a new table when a project table already exists | Search local docs first and guide the user to the current table. |
| Pasting a raw bug list into one long text field | Split it into structured task records with type, priority, owner, impact, evidence, expected result, and acceptance criteria. |
| Creating separate task tables for each campus | Use a target campus/scope field unless the project explicitly requires separate tables. |
| Recording a feedback package as a push record | Treat problem descriptions and screenshots as task board intake unless the user explicitly asks for a push/update record. |
| Letting closed items fill the development kanban | Filter out closed status records in active development views. |
| Seeing an "未分类" kanban lane after design changes | Remove blank auto-created records and filter the view to records with a non-empty task id. |
| Building dashboard charts with `dimension` or `dimensions` | Use the CLI-supported `group_by` data configuration and verify block data after creation. |
| Missing table link or Base identifiers | Stop and ask the user to get the current table link from the project owner or provide their own table link/config. |
| Uploading screenshots because a record was synced | Keep screenshots/evidence local unless the user explicitly asked for external attachment upload. |
| Using a live fallback page as the visual proof | Capture the current branch's complete target-state UI; live-current images are supplemental only. |
| Guessing `lark-cli` fields after an auth/scope error | Stop at the permission boundary and report the missing scope or login requirement. |
| Presenting the skill as backend-ready | State that it is frontend-led unless backend-specific docs, field mapping, commands, and scopes are configured. |

## Verification Checklist

- [ ] Current project rules and Feishu/Base table source were read.
- [ ] Requested mode was classified as push ledger, task board, dashboard/view maintenance, attachment sync, or draft-only.
- [ ] `lark-cli` binary, auth context, and required Base permissions were confirmed.
- [ ] Base/table/field/view/dashboard schema was fetched before writes, unless an exact current schema was supplied.
- [ ] Branch, commit SHA, MR/deploy link, task ids, dashboard ids, and verification results were not invented.
- [ ] Backend-facing docs referenced in the collaboration note are repo-visible.
- [ ] Task board records are structured and not raw pasted text.
- [ ] Active development views hide closed records and filter out blank task ids.
- [ ] PM dashboard blocks were read back and produced non-empty data when data exists.
- [ ] Screenshot/evidence upload was skipped unless explicitly requested.
- [ ] Record/view/dashboard was read back after create/update and final status separated local docs, Feishu records, pushed code, deployed code, dashboards, attachments, and live verification.
