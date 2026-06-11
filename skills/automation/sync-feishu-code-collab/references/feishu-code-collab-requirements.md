# Feishu Code Collaboration Requirements

Use this reference for the detailed checklist after `SKILL.md` triggers.

## Discover Project Rules

Start from the target repo and search for local policy:

```bash
rg -n "飞书|Base|协同|推送记录|前后端|用户反馈录入|反馈入板|任务看板|PM 进度总览|Bug 修复池|待优化池|测试用例|目标校区|问题截图/附件|页面修改截图|style-screenshots|lark-cli|Codeup" AGENTS.md CLAUDE.md docs style-screenshots 2>/dev/null
```

Common project-local sources include:

- root agent instructions such as `AGENTS.md` / `CLAUDE.md`
- latest `handoff/*-handoff.md`
- tooling docs, especially Codeup/Git push rules and protected local artifact rules
- a dedicated Feishu/Base collaboration doc
- task board or product-quality docs
- screenshot/evidence docs or templates such as `style-screenshots/README.md`
- backend collaboration docs such as `docs/backend-collab/**`
- quality/test history docs that backend can actually view

If local docs identify the current Feishu/Base collaboration table, use that Base first. Do not ask the user to create a new Base when a current project Base is available and readable.

If no current table link/Base identifiers can be found, or the local docs are too incomplete for an external write, stop before writing and ask the user to:

- get the current Feishu/Base table link from the project owner; or
- create their own Feishu/Base table and provide its link/configuration.

Also ask for:

- target workflow: push ledger, user-feedback intake, task board, dashboard/view maintenance, attachment sync, or draft-only
- table/view/dashboard or record id
- required fields and field types
- what docs are counterpart-visible
- screenshot or evidence upload policy
- whether this is a draft-only task or an external write

## Current Frontend Bias

This skill is currently configured for frontend-led collaboration:

- frontend branch, commit, MR, push, and deployment evidence
- frontend-visible validation such as test/lint/build, local dev, static export, shared dev, staging, or production checks
- UI/copy/interaction screenshot batches
- frontend-authored backend review docs, such as API gap notes, field-contract notes, quality history, and current issue queues
- product-quality task board maintenance when the Base is used to coordinate bugs, optimizations, refactors, requirements, PM progress, evidence attachments, and future test-case source tracking

Backend usage is allowed only after the backend side supplies its own rules:

- backend repo/module naming and branch/commit source
- backend-visible docs and issue queues
- Base field mapping for backend-only, deployment, or task records
- backend verification commands and environment labels
- attachment policy, if any
- task ownership and status taxonomy, if the backend also owns board updates
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
- view and dashboard read ability before reshaping task board surfaces
- record create/update/read ability for text sync
- attachment upload ability only when the user explicitly requests screenshot or evidence upload
- project-local source for Base name/token, table id, view id, dashboard id, attachment field id, and field names

When the CLI returns missing scope, auth, or permission errors, stop and report the exact missing boundary. Do not silently switch to bot context, guess field IDs, or fabricate JSON.

## Push Ledger Field Mapping

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

## Task Board / Product Backlog Mode

Use task board mode when the user asks to maintain bugs, optimizations, refactors, new requirements, PM overview, test-case source tracking, task evidence, or a Linear-like development flow inside the same collaboration Base.

Use this mode by default when the user directly provides a feedback package such as:

- problem description
- screenshot, video, or attachment path
- affected page, role, campus, device, browser, account type, or operation path
- error code, user quote, or observed behavior
- expected behavior or desired optimization

Do not put these feedback packages into the push-record ledger unless the user explicitly says it is a code push/update record.

Session upgrade pattern to preserve:

- Keep the existing push-record table intact.
- Add or maintain a separate task board table/block inside the same Base when the project uses one.
- Do not create a separate table for each rollout campus. Use a target campus/scope field instead.
- Do not create a separate "internal test plan" table unless the user explicitly asks for it. Internal-test scope can live on the task records or in views.
- Use P0/P1/P2/P3 priority as the main development-flow grouping when the user says phase labels such as "内测修复", "上线前", or "后续优化" are unclear.
- Prefer a dedicated PM progress dashboard for cross-cutting totals and risk distribution rather than overloading the development kanban.
- Attach bug/optimization screenshots, videos, and evidence to a task evidence attachment field, not to a push-record style-screenshot field.
- Future test cases should be generated from confirmed bug tasks in the board, not from ad hoc notes.

Recommended task fields:

| Meaning | Notes |
|---|---|
| Task id | Required for active views; use a stable prefix/sequence if the project has one. |
| Title | PM-readable, concise, action-oriented. Do not paste the full raw bug sentence as the title. |
| Type | Bug, optimization, refactor, new requirement, or project-specific equivalents. |
| Status | Intake, waiting confirmation, to do, in progress, ready for test, testing, closed, blocked, or project-specific equivalents. |
| Priority | P0/P1/P2/P3 or project-defined severity. Use this for the active development kanban when requested. |
| Owner | Use project-defined options/defaults. Do not invent owners. |
| Collaborator | Optional counterpart such as frontend/backend/product/test. |
| Impacted side | Teacher side, admin side, backend/data, export, login/auth, cross-side, or project terms. |
| Target campus/scope | Multi-select scope such as pilot campus, future campus, all campuses, or pending confirmation. |
| Phenomenon | What the user observed. Preserve semantics, but rewrite into clear product language. |
| Expected result | What should happen instead. |
| Reproduction/evidence | Steps, error code, affected page, device/browser, or evidence pointer. |
| Acceptance criteria | Observable completion conditions for product and development. |
| Blocker | What prevents closure or testing. |
| Test-case status | Not generated, pending design, generated, covered, not applicable, or project terms. |
| Release gate | Whether this blocks pilot/internal test/release, expressed in project terms. |
| Attachment/evidence | Evidence files only when external upload is approved. |

When converting a user-provided list:

- Split one bullet into one task unless the bullet clearly contains two independent defects.
- Merge duplicate descriptions only when the same symptom, same expected behavior, and same impacted surface are clear.
- Rewrite raw notes into structured fields, but preserve error codes, device names, campus names, page names, and exact business semantics.
- Mark already-fixed or already-closed items as closed only when the user explicitly marked them done or current evidence proves closure.
- Use "待确认" or an equivalent field value for unclear campus, owner, reproduction, or impact instead of inventing detail.

When converting a direct feedback package:

- Use the feedback description to create a concise title and a structured phenomenon field.
- Convert screenshots/videos into task evidence only when external upload is approved; otherwise record the local evidence path or leave the attachment empty according to project policy.
- Infer impacted side only from explicit context or obvious page ownership. If unclear, use a pending-confirmation value.
- If a device/browser is named, preserve it in reproduction/evidence.
- If a campus is named, set the target campus/scope field; if the feedback may affect all campuses, use the project-defined global/all-campus option.
- Set the owner from project configuration. If the project defines active owners such as `kt` and `alex` and a default owner, apply that config; otherwise ask or mark pending rather than inventing.
- Set test-case status to not generated/pending design unless the task already has a linked test case.
- Add acceptance criteria in PM-readable terms so development can know when the task is done.

## View Rules For Task Boards

Recommended views for a product-quality task board:

- `产品总览`: broad PM-readable table view.
- `PM 进度总览`: dashboard, not a duplicate task table, when dashboard features are available.
- `P0/P1 紧急`: filtered active high-priority view.
- `开发流看板`: kanban grouped by priority or status, depending on project preference.
- `Bug 修复池`: bug-focused active view.
- `待优化池`: optimization-focused active view.
- `需求/重构池`: refactor and new-requirement view.

Active development views should hide closed and blank records. When a kanban grouped by priority shows an unwanted `未分类` lane after design or dashboard changes, check for blank auto-created records and add a non-empty task-id filter.

Typical development-flow filter:

```json
{
  "logic": "and",
  "conditions": [
    ["状态", "disjoint", ["已关闭"]],
    ["任务编号", "isNotEmpty", null]
  ]
}
```

The CLI may normalize `isNotEmpty` to `non_empty` when reading the filter back. Either representation is acceptable when the read-back result is correct.

Typical development-flow grouping:

```json
{"field_name":"优先级","group_order":["P0 阻塞","P1 高","P2 中","P3 低"]}
```

Do not leave a view called "未分类" or a visible uncategorized lane as the expected final state. It usually means blank records or missing priority data, not a product concept.

## PM Dashboard Rules

A PM progress dashboard should answer "what is open, risky, blocked, ready for test, and missing test coverage" without forcing the PM to scan every row.

Useful blocks:

- total task count
- active P0 count
- active P1 count
- status distribution
- priority/risk distribution
- task type distribution
- test-case status distribution
- optional owner or impacted-side distribution

For dashboard grouped charts, use `group_by` in `data_config`. Do not use `dimension` or `dimensions`.

Example grouped chart data config:

```json
{
  "table_name": "任务看板",
  "count_all": true,
  "group_by": [
    {
      "field_name": "状态",
      "mode": "integrated",
      "sort": {"type": "value", "order": "desc"}
    }
  ]
}
```

Example active P0 count config:

```json
{
  "table_name": "任务看板",
  "count_all": true,
  "filter": {
    "conjunction": "and",
    "conditions": [
      {"field_name": "优先级", "operator": "is", "value": ["P0 阻塞"]},
      {"field_name": "状态", "operator": "isNot", "value": ["已关闭"]}
    ]
  }
}
```

For select filters in dashboard configs, pass option labels as strings unless current CLI/project docs prove a different shape is required.

After creating or changing dashboard blocks, call the dashboard block data read command and verify the block returns plausible data. Remove or repair any experimental blocks that were created with the wrong config.

## Lark CLI Command Templates

Always use `--as user`. Replace placeholders from project docs or user input:

```bash
lark-cli docs +search --query "<collaboration-base-name>" --filter '{"doc_types":["BITABLE"]}' --as user
lark-cli base +base-get --base-token "<base-token>" --as user
lark-cli base +table-list --base-token "<base-token>" --as user
lark-cli base +field-list --base-token "<base-token>" --table-id "<table-id>" --as user
lark-cli base +view-list --base-token "<base-token>" --table-id "<table-id>" --as user
lark-cli base +record-upsert --base-token "<base-token>" --table-id "<table-id>" --json '<record-json>' --as user
lark-cli base +record-get --base-token "<base-token>" --table-id "<table-id>" --record-id "<record-id>" --format json --as user
```

For task-board view maintenance:

```bash
lark-cli base +view-get-filter --base-token "<base-token>" --table-id "<table-id>" --view-id "<view-id>" --as user
lark-cli base +view-set-filter --base-token "<base-token>" --table-id "<table-id>" --view-id "<view-id>" --filter '<filter-json>' --as user
lark-cli base +view-get-group --base-token "<base-token>" --table-id "<table-id>" --view-id "<view-id>" --as user
lark-cli base +view-set-group --base-token "<base-token>" --table-id "<table-id>" --view-id "<view-id>" --group '<group-json>' --as user
```

For dashboard maintenance:

```bash
lark-cli base +dashboard-list --base-token "<base-token>" --as user
lark-cli base +dashboard-create --base-token "<base-token>" --name "<dashboard-name>" --as user
lark-cli base +dashboard-block-create --base-token "<base-token>" --dashboard-id "<dashboard-id>" --json '<block-json>' --as user
lark-cli base +dashboard-block-get-data --base-token "<base-token>" --dashboard-id "<dashboard-id>" --block-id "<block-id>" --as user
lark-cli base +dashboard-arrange --base-token "<base-token>" --dashboard-id "<dashboard-id>" --layout '<layout-json>' --as user
```

For attachment upload:

```bash
lark-cli base +record-upload-attachment --base-token "<base-token>" --table-id "<table-id>" --record-id "<record-id>" --field-id "<attachment-field-id>" --file "<relative/path/from/current/workdir.png>" --as user
```

Attachment uploads should use stable local files from the approved batch directory, one file per call. Prefer relative file paths from the current working directory when the CLI requires them.

## Screenshot And Task Evidence Policy

Default stance:

- Text record sync does not imply screenshot or evidence upload permission.
- Store visual evidence locally unless the user explicitly requests external upload.
- Use a batch folder, not loose root-level images.
- Prefer complete target-state screenshots rendered by the current branch.
- Use current live screenshots only as supplemental evidence when live data has not caught up.
- For task board bugs/optimizations, upload files to the configured task evidence field only when external upload is approved.
- Do not mix task evidence attachments with push-record frontend screenshot attachments unless the project's schema intentionally reuses one attachment field.
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

- Base name and record/task id, if known
- commit SHA and branch
- capture date
- related routes/pages
- change summary
- screenshot or evidence type, such as `frontend-target-state-preview`, `live-current-state`, or `task-evidence`
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
- Tokens, Base IDs, table IDs, view IDs, dashboard IDs, field IDs, phone numbers, verification codes, credentials, and private account data must not be copied into public docs or commits unless the project explicitly classifies them as safe.

When a hook blocks a commit or push, do not bypass it with allow variables until you understand whether the blocked file is intentionally protected.

## Final Report Checklist

Report:

- target repo/project
- selected mode: push ledger, task board, dashboard/view maintenance, attachment sync, or draft-only
- branch and commit SHA, when code sync was involved
- Feishu record id/number, task count, view/dashboard names, or draft-only status
- docs referenced for counterpart review
- verification actually run, with failures or skipped checks
- screenshot/evidence batch path and whether attachments were uploaded
- dashboard or view read-back result when the work changed dashboards/views
- authorization, scope, or missing-policy blockers

Keep the report short and distinguish local docs, repo-visible docs, Feishu records, pushed code, deployed code, task board state, dashboards/views, attachments, and live verification.
