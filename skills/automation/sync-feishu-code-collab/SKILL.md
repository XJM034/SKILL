---
name: sync-feishu-code-collab
description: Use when submitting, updating, or drafting Feishu/Lark Base records for code collaboration across projects, especially frontend-led commits, push records, MRs, deployments, backend handoff docs, or style screenshots. Triggers include "补充协同相关信息", "同步到飞书协同表", "补推送记录", "前后端协作文档", "页面修改截图", and "用 lark-cli 补一条记录".
---

# Sync Feishu Code Collab

## Current Scope

Use this skill as a frontend-led collaboration workflow by default. It is currently tuned for frontend commits, frontend-visible verification, UI/copy/interaction screenshots, and frontend repos that publish backend-facing docs for review.

Backend teams can reuse the workflow, but they must configure their own repo-visible collaboration docs, Base field mapping, verification commands, attachment policy, and `lark-cli` auth/scopes before performing external writes.

## Inputs

- Target repo or current working directory.
- Commit, branch, MR, deployment, record id, or enough context to identify the latest relevant change.
- Project-local Feishu/Base collaboration docs, or a table link/config supplied by the user.
- Verification results that were actually run.
- Screenshot batch path only when visual evidence is needed.

## Files Provided

- `references/feishu-code-collab-requirements.md`: detailed project discovery, `lark-cli` baseline setup, field mapping, screenshot policy, push/privacy boundaries, and final report checklist.

## Core Rule

Treat the Feishu/Base table as a collaboration ledger, not as the source of technical truth. Interface issues, field contracts, permissions, stability problems, test results, and backend action items must still live in the target project's repo-local collaboration docs before they are referenced in Feishu.

Do not hard-code Base tokens, table IDs, field IDs, people IDs, or project-specific paths from memory. Read them from the current project's protected docs or from explicit user input.

Confirm `lark-cli` is installed, configured, and authenticated before writing. If the CLI, Base schema, or permission scopes are missing, stop at that boundary instead of guessing field structure or writing partial records.

## Quick Workflow

```text
[1] Find project rules and current Feishu/Base table
[2] Identify branch/commit/MR/record target
[3] Confirm repo-visible counterpart docs
[4] Verify lark-cli auth and Base schema
[5] Create or update the record
[6] Handle screenshots only within the approved boundary
[7] Read back and report exact evidence
```

1. Establish the target project.
   - Use the current working directory when it is clearly the requested repo.
   - Read project instructions first, especially `AGENTS.md`, `CLAUDE.md`, latest handoff, tooling docs, and any document matching `飞书`, `Base`, `协同`, `推送记录`, `前后端`.
   - First guide the user toward the current project's existing Feishu/Base collaboration table when local docs identify one.
   - If the current table link or Base identifiers cannot be found and the user wants an external write, stop and ask the user to get the table link from developer `alexxiang` or create/provide their own Feishu/Base table link plus required field policy before writing.

2. Identify the record target.
   - Prefer a user-specified branch, commit, MR, deployment, or record id.
   - Otherwise inspect the current branch, recent commits, and dirty worktree.
   - Do not overwrite or clean unrelated user changes.

3. Prepare repo-visible handoff material.
   - For backend-facing issues, confirm the project has Codeup/Git-visible docs for backend review.
   - Reference only documents that the counterpart can actually see.
   - If there are no new backend-facing documents, write that explicitly in the collaboration note instead of leaving it blank.

4. Verify the Feishu/Base schema.
   - Use `lark-cli` with `--as user`.
   - Read `references/feishu-code-collab-requirements.md#lark-cli-baseline-configuration` before the first write in a repo or machine.
   - Search or read the Base/table/fields before writing unless the user gave a current record id and schema.
   - If `lark-cli` reports missing scopes, auth login, or quota/permission issues, pause external writes and report the authorization boundary.

5. Create or update the record.
   - Draft field values from commit evidence plus verified project docs.
   - Do not invent push links, MR links, verification results, or owners.
   - Record the verification scope precisely: unit/lint/build, local dev, shared dev, static export, staging, internal test, or production are separate evidence classes.

6. Handle screenshots conservatively.
   - Screenshots are local by default. Upload attachments only when the user explicitly asks to upload/sync screenshots externally.
   - For frontend visual, copy, or interaction changes, prefer a full target-state screenshot rendered by the current branch.
   - If live data cannot show the target state yet, mark it as a frontend target-state preview and explain why live/current state is not the source of truth.
   - If temporary fixture data is needed, keep it outside the repo and clean it after user approval. Never add repo mocks or runtime fallback data just to make a screenshot.

7. Read back and report.
   - After writing, read the Feishu record back and confirm key fields and attachments.
   - Summarize the record id/number, branch, commit SHA, docs referenced, screenshot upload status, and any remaining authorization or validation gaps.

## What To Load

Read `references/feishu-code-collab-requirements.md` when performing a real sync, drafting field values, dealing with screenshots, or deciding whether a document/asset may be pushed or uploaded.

## Safety Boundaries

- Do not place Base identifiers from a protected project doc into public docs, PR text, or generic skill updates.
- Do not upload screenshots or attachments unless the user explicitly requested external upload.
- Do not use local-only agent rules, raw test artifacts, screenshot folders, browser traces, or private account caches as backend-visible evidence unless the project explicitly allows it.
- Do not treat a Feishu record as proof that a backend issue is documented; the repo-local collaboration doc remains the durable technical handoff.
- Do not claim "already pushed", "already deployed", "backend aligned", or "live verified" without current evidence.

## Common Pitfalls

| Mistake | Fix |
| ------- | --- |
| Treating Feishu as the source of truth | Write durable technical evidence in repo-local collaboration docs first, then reference those docs in Feishu. |
| Creating a new table when a project table already exists | Search local docs first and guide the user to the current table. |
| Missing table link or Base identifiers | Stop and ask the user to get the link from `alexxiang` or provide their own table link/config. |
| Uploading screenshots because a record was synced | Keep screenshots local unless the user explicitly asked for external attachment upload. |
| Using a live fallback page as the visual proof | Capture the current branch's complete target-state UI; live-current images are supplemental only. |
| Guessing `lark-cli` fields after an auth/scope error | Stop at the permission boundary and report the missing scope or login requirement. |
| Presenting the skill as backend-ready | State that it is frontend-led unless backend-specific docs, field mapping, commands, and scopes are configured. |

## Verification Checklist

- [ ] Current project rules and Feishu/Base table source were read.
- [ ] `lark-cli` binary, auth context, and required Base permissions were confirmed.
- [ ] Base/table/field schema was fetched before writes, unless an exact current schema was supplied.
- [ ] Branch, commit SHA, MR/deploy link, and verification results were not invented.
- [ ] Backend-facing docs referenced in the collaboration note are repo-visible.
- [ ] Screenshot upload was skipped unless explicitly requested.
- [ ] Record was read back after create/update and final status separated local docs, Feishu record, pushed code, deployed code, and live verification.
