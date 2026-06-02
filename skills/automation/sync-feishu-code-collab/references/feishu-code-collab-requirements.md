# Feishu Code Collaboration Requirements

Use this reference for the detailed checklist after `SKILL.md` triggers.

## Discover Project Rules

Start from the target repo and search for local policy:

```bash
rg -n "飞书|Base|协同|推送记录|前后端|页面修改截图|style-screenshots|lark-cli|Codeup" AGENTS.md CLAUDE.md docs style-screenshots 2>/dev/null
```

Common project-local sources include:

- root agent instructions such as `AGENTS.md` / `CLAUDE.md`
- latest `handoff/*-handoff.md`
- tooling docs, especially Codeup/Git push rules and protected local artifact rules
- a dedicated Feishu/Base collaboration doc
- screenshot evidence docs or templates such as `style-screenshots/README.md`
- backend collaboration docs such as `docs/backend-collab/**`
- quality/test history docs that backend can actually view

If local docs identify the current Feishu/Base collaboration table, use that table first. Do not ask the user to create a new table when a current project table is available and readable.

If no current table link/Base identifiers can be found, or the local docs are too incomplete for an external write, stop before writing and ask the user to:

- get the current Feishu/Base table link from developer `alexxiang`; or
- create their own Feishu/Base table and provide its link/configuration.

Also ask for:

- table/view or record id
- required fields and field types
- what docs are backend-visible
- screenshot upload policy
- whether this is a draft-only task or an external write

## Current Frontend Bias

This skill is currently configured for frontend-led collaboration records:

- frontend branch, commit, MR, push, and deployment evidence
- frontend-visible validation such as test/lint/build, local dev, static export, shared dev, staging, or production checks
- UI/copy/interaction screenshot batches
- frontend-authored backend review docs, such as API gap notes, field-contract notes, quality history, and current issue queues

Backend usage is allowed only after the backend side supplies its own rules:

- backend repo/module naming and branch/commit source
- backend-visible docs and issue queues
- Base field mapping for backend-only or deployment records
- backend verification commands and environment labels
- attachment policy, if any
- required `lark-cli` account, auth context, and scopes

Until those backend rules are configured, do not present this skill as a backend-ready automation.

## Lark CLI Baseline Configuration

Use the current project docs first. For a new machine or unclear setup, verify these basics before external writes:

```bash
command -v lark-cli
lark-cli --version
lark-cli config init --new
lark-cli auth login --recommend
```

Per current Context7 docs for `/larksuite/cli`, the general setup path is:

```bash
npm install -g @larksuite/cli
npx skills add larksuite/cli -y -g
lark-cli config init --new
lark-cli auth login --recommend
```

Do not rerun installation or login if the user's machine is already configured and the project policy says to reuse the existing setup.

For this skill, require:

- `lark-cli` binary available in the active shell or agent runtime
- authenticated user context; default to `--as user`
- Base/table/field read ability before writing records
- record create/update/read ability for text sync
- attachment upload ability only when the user explicitly requests screenshot upload
- project-local source for Base name/token, table id, attachment field id, and field names

When the CLI returns missing scope, auth, or permission errors, stop and report the exact missing boundary. Do not silently switch to bot context, guess field IDs, or fabricate a record JSON.

## Record Field Mapping

Use project-specific field names when available. These generic meanings usually map well:

| Meaning | Default source |
|---|---|
| Push title | Side/module plus concise change summary |
| Side | Frontend, backend, frontend/backend collaboration, deployment/ops, or actual project category |
| Status | Usually pushed/submitted unless the user states pending, blocked, or validating |
| Repo/module | Verified repo or module name |
| Branch | User-provided branch or current branch |
| Commit time | Relevant commit time, formatted in the project timezone |
| Commit version | Full commit SHA; short SHA may appear in notes |
| Push/MR/deploy link | Only real links; leave blank when unknown |
| Change summary | Commit subject plus verified diff/user context |
| Impacted pages/APIs | Verified routes, screens, services, or endpoints |
| Collaboration note | Human-readable context, backend-visible doc paths, validation scope, risks, and counterpart asks |
| Needs counterpart confirmation | Set only when frontend/backend review is actually needed |
| Confirmation result | Unknown/unconfirmed unless explicitly resolved |
| Owner/contact | Only from user input or reliable project docs |
| Verification result | Actual commands/environments run; do not infer |
| Screenshot attachment | Empty by default unless external upload was explicitly requested |

For backend-facing collaboration notes, include repo-visible document paths. If none were added, explicitly write `本轮无新增后端需查看文档` or the project-equivalent wording.

## Lark CLI Command Templates

Always use `--as user`. Replace placeholders from project docs or user input:

```bash
lark-cli docs +search --query "<collaboration-base-name>" --filter '{"doc_types":["BITABLE"]}' --as user
lark-cli base +base-get --base-token "<base-token>" --as user
lark-cli base +table-list --base-token "<base-token>" --as user
lark-cli base +field-list --base-token "<base-token>" --table-id "<table-id>" --as user
lark-cli base +record-upsert --base-token "<base-token>" --table-id "<table-id>" --json '<record-json>' --as user
lark-cli base +record-get --base-token "<base-token>" --table-id "<table-id>" --record-id "<record-id>" --format json --as user
```

For attachment upload:

```bash
lark-cli base +record-upload-attachment --base-token "<base-token>" --table-id "<table-id>" --record-id "<record-id>" --field-id "<attachment-field-id>" --file "<relative/path/from/current/workdir.png>" --as user
```

Attachment uploads should use stable local files from the approved batch directory, one file per call. Prefer relative file paths from the current working directory when the CLI requires them.

## Screenshot Evidence Policy

Default stance:

- Text record sync does not imply screenshot upload permission.
- Store visual evidence locally unless the user explicitly requests external upload.
- Use a batch folder, not loose root-level images.
- Prefer complete target-state screenshots rendered by the current branch.
- Use current live screenshots only as supplemental evidence when live data has not caught up.
- Do not replace target-state screenshots with cropped structure-only images, redacted placeholders, hand-made mockups, manually stitched images, unrelated historical screenshots, or a fallback live page that still lacks the backend fields needed to show the new UI.
- For frontend visual, copy, or interaction changes, the source-of-truth screenshot is the full intended page state from the current branch. Optional expanded, interaction, or live-current images can supplement it, not replace it.

Batch folder pattern:

```text
YYYYMMDD-HHMM-<page-or-flow>-<change-summary>/
  MANIFEST.md
  01-<page>-<state-or-action>.png
  02-<page>-<state-or-action>.png
```

`MANIFEST.md` should include:

- Base name and record id, if known
- commit SHA and branch
- capture date
- related routes/pages
- change summary
- screenshot type, such as `frontend-target-state-preview` or `live-current-state`
- whether it is full-page
- fixture path and cleanup command when temporary fixture data was used
- why live/current state can or cannot represent the target UI

If fixture data is necessary:

- Keep it outside the repo, typically `/private/tmp` or the system temp directory.
- Inject it only for the screenshot session, for example through a project-provided Playwright screenshot script.
- Do not add mocks, service fallbacks, or runtime fake data in the app.
- After user approval, delete the fixture and verify no repo mock/fallback residue remains.
- If a fixture is used because backend fields are not connected yet, mark the screenshot and `MANIFEST.md` as `frontend-target-state-preview`; do not describe it as backend-connected, shared-dev verified, staging verified, or production verified.

## Push And Privacy Boundaries

Before committing or pushing collaboration work, read the project's push guardrails. Typical boundaries:

- Backend-visible docs may include backend collaboration docs, quality history, regression results, and public handoff docs that the project explicitly allows.
- Local-only docs may include agent instructions, local testing rules, private account caches, raw Playwright/test artifacts, screenshot binaries, browser traces, and local tooling notes.
- Screenshots may be local-only even when their `MANIFEST.md` is allowed to remain as structure documentation.
- Tokens, Base IDs, table IDs, field IDs, phone numbers, verification codes, credentials, and private account data must not be copied into public docs or commits unless the project explicitly classifies them as safe.

When a hook blocks a commit or push, do not bypass it with allow variables until you understand whether the blocked file is intentionally protected.

## Final Report Checklist

Report:

- target repo/project
- branch and commit SHA
- Feishu record id/number or draft-only status
- docs referenced for counterpart review
- verification actually run, with failures or skipped checks
- screenshot batch path and whether attachments were uploaded
- authorization, scope, or missing-policy blockers

Keep the report short and distinguish local docs, repo-visible docs, Feishu records, pushed code, deployed code, and live verification.
