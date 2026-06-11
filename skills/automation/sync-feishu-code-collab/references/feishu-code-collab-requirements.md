# Feishu Code Collaboration Requirements

Use this reference for the detailed checklist after `SKILL.md` triggers.

## Discover Project Rules

Start from the target repo and search for local policy:

```bash
rg -n "飞书|Base|协同|推送记录|前后端|用户反馈录入|反馈入板|任务看板|PM 进度总览|Bug 修复池|待优化池|测试用例|测试执行记录|Bug 派生用例|发布门禁|待补全用例|目标校区|问题截图/附件|页面修改截图|style-screenshots|lark-cli|Codeup" AGENTS.md CLAUDE.md docs style-screenshots 2>/dev/null
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
- test-case repository maintenance when the Base links task-board bugs and selected high-risk optimizations to long-lived regression or acceptance cases
- test execution record maintenance when actual runs need durable evidence, failed-test backflow, write-impact tracking, or release-gate status

Backend usage is allowed only after the backend side supplies its own rules:

- backend repo/module naming and branch/commit source
- backend-visible docs and issue queues
- Base field mapping for backend-only, deployment, or task records
- backend verification commands and environment labels
- attachment policy, if any
- task ownership and status taxonomy, if the backend also owns board updates
- required `lark-cli` account, auth context, and scopes

Until those backend rules are configured, do not present this skill as a backend-ready automation.

## Project-Specific Base Schema Profiles

This skill stays generic, so do not hardcode Base tokens, table ids, field ids, secrets, phones, verification codes, or private account material in the skill itself. When a project exposes stable Feishu table structure in protected project docs or live Base reads, keep only a token-free schema profile here: table names, view names, field names, option labels, and filling rules.

### 到了么 / bordeaux Collaboration Base Profile

Use this profile when the repo docs identify the target Base as `到了么｜前后端代码推送协同表`. Read the current token, table ids, field ids, view ids, and dashboard ids from protected project docs or live `lark-cli base` output, not from this skill.

Expected left-side blocks:

- `推送记录`: code push / MR / deploy collaboration ledger only.
- `任务看板`: Bug, optimization, refactor, and new requirement backlog.
- `测试用例`: long-lived regression case repository.
- `测试执行记录`: one row per case run or batch execution result.
- `PM 进度总览`: PM-facing overview / dashboard.

Known task-board views:

- `产品总览`
- `P0/P1 紧急`
- `开发流看板`
- `Bug 修复池`
- `待优化池`
- `需求/重构池`
- `Bug 未派生用例`
- `P0/P1 待测`
- `待验证任务`

Known test-case views:

- `全部用例`
- `发布门禁`
- `Bug 派生回归`
- `老师端`
- `管理端`
- `跨端联动`
- `待补全`
- `适合自动化`
- `长期复测池`

Known execution-record views:

- `最近执行`
- `失败/阻塞`
- `Bug 回流待处理`
- `写流待恢复`
- `证据不足`
- `发布回归批次`

#### `推送记录` Fields And Filling Rules

Core fields:

- `推送标题`
- `记录编号`
- `端别`
- `状态`
- `仓库/模块`
- `分支名称`
- `提交时间`
- `提交版本号`
- `推送/MR/部署链接`
- `更改说明`
- `影响页面/接口`
- `页面修改截图（前端）`
- `协同说明`
- `是否需要对方确认`
- `确认结果`
- `负责人`
- `对接/确认人`
- `验证结果`

Filling requirements:

- Use `推送记录` only for code push / MR / deploy coordination. Do not put task backlog, test cases, or execution results here.
- `协同说明` must list backend-visible Codeup/project document paths for this round. If there are no new backend-readable docs, explicitly write `本轮无新增后端需查看文档`.
- `页面修改截图（前端）` is empty by default. Keep screenshots local unless the user explicitly requests external upload.
- Separate frontend and backend changes. Do not mix backend implementation details into a frontend push record unless it is only a coordination reference.

#### `任务看板` Fields And Filling Rules

Core fields:

- `任务编号`
- `标题`
- `类型`: `Bug`, `待优化`, `待重构`, `新需求`
- `状态`: `待确认`, `待排期`, `开发中`, `待验证`, `已关闭`
- `优先级`: `P0 阻塞`, `P1 高`, `P2 中`, `P3 低`
- `项目负责人`: `kt`, `alex` (default to `kt` unless project context says otherwise)
- `影响端`: `老师端`, `管理端`, `后端接口`, `导出复制`, `登录权限`, `排课/课程`, `移动端兼容`
- `目标校区`: `金牛`, `云芯`, `成华`, `彭州`, `多校区`, `全局`, `待确认`
- `测试用例状态`: `未生成`, `待设计`, `待执行`, `已通过`, `不需要`
- `排期备注（可选）`: `内测修复`, `上线前`, `后续优化`, `待确认`
- `协同方`: `前端`, `后端`, `PM`, `测试`, `KT`, `待确认`
- `上线前置`: `测试用例通过后上线`, `PM 验收后上线`, `不阻塞上线`, `待确认`
- `现象描述`
- `期望结果`
- `复现/证据`
- `验收标准`
- `关联记录`
- `阻塞原因`
- `备注`
- `问题截图/附件`
- `父记录` / linked record field, if present

Filling requirements:

- Task items belong in `任务看板`, not `推送记录`.
- Put campus scope in `目标校区`; do not create separate campus tables for 金牛、云芯、成华、彭州.
- Put task evidence and screenshots in `问题截图/附件`, not in the push-record screenshot field.
- Current project-owner options are only `kt` / `alex`; default to `kt` when no explicit owner is given.
- Closed bugs can still be valid regression seeds. Do not exclude them from test-case derivation only because they are closed.

#### `测试用例` Fields And Filling Rules

Core fields:

- `用例编号`
- `用例标题`
- `来源类型`: `任务 Bug 派生`, `核心链路`, `历史回归`, `发布门禁`, `兼容性`, `接口契约`, `人工探索沉淀`
- `关联任务`
- `模块`: `登录与会话`, `老师端点名`, `管理端未到学生`, `临时学生`, `管理端合班换课代课`, `系统外老师边界`, `应急调整边界`, `管理端课程与总控`, `课程设置`, `安全与权限`, `兼容与静态导出`, `时间设置与复制`, `性能与主链`, `发布门禁`
- `角色范围`: `管理端`, `老师端`, `多校区管理员`, `系统外老师`, `跨端联动`, `后端接口`
- `优先级`: `P0 核心`, `P1 重要`, `P2 补充`, `P3 观察`
- `门禁级别`: `发布必跑`, `修复后必跑`, `周回归`, `月回归`, `按需`
- `复测频率`: `每次发布`, `相关模块变更`, `Bug 修复后`, `每周`, `每月`, `暂不复测`
- `适用环境`: `shared dev`, `内测`, `线上`, `静态产物`, `代码静态判断`
- `是否写流`: `只读`, `低风险写入可恢复`, `高风险写入需确认`, `不可执行仅代码判断`
- `前置条件`
- `操作步骤`
- `预期结果`
- `证据要求`: `截图`, `接口响应`, `控制台`, `剪贴板摘要`, `git status`, `测试报告路径`
- `自动化候选`: `已自动化`, `适合自动化`, `只适合人工`, `暂不确定`
- `用例状态`: `待设计`, `可执行`, `需补信息`, `暂停`, `废弃`
- `维护负责人`: `alex`, `kt`, `测试/待定`
- `最近结果`: `通过`, `失败`, `阻塞`, `部分通过`, `未执行`, `不适用`
- `最近执行时间`
- `备注`

Filling requirements:

- Task-board Bug rows are the default seed source for `任务 Bug 派生` cases, including already fixed or closed bugs that should become regression cases.
- Pull in optimization rows only when they are high-risk or user-impacting, such as cross-end consistency, permissions, write flow, login/session, export/copy, mobile compatibility, or release gate behavior.
- Creating/importing a test case is not executing the case. Do not create `测试执行记录` during import unless a real test run happened.
- After creating cases, read back the linked case rows and then update the source task `测试用例状态` to `待执行` or `待设计` as appropriate.
- If a task lacks enough reproduction detail or expected behavior, create the case as `需补信息` and keep the missing information visible in `备注` or `前置条件`.
- Long-lived regression cases should have explicit `门禁级别`, `复测频率`, `适用环境`, `是否写流`, and `证据要求` so future non-professional testers can execute them consistently.

#### `测试执行记录` Fields And Filling Rules

Core fields:

- `执行编号`
- `关联用例`
- `执行批次`
- `执行类型`: `发布回归`, `Bug 复测`, `专项测试`, `冒烟`, `只读核验`, `写流验证`
- `执行环境`: `shared dev`, `内测`, `线上`, `静态产物`, `本机代码`
- `执行角色`: `管理端`, `老师端`, `多校区管理员`, `系统外老师`, `跨端联动`, `后端接口`
- `目标校区`: `金牛`, `云芯`, `成华`, `彭州`, `多校区`, `全局`, `待确认`
- `业务对象`
- `执行步骤摘要`
- `结果`: `通过`, `失败`, `阻塞`, `部分通过`, `未执行`, `不适用`
- `归属`: `前端`, `后端`, `数据`, `权限`, `环境`, `测试账号`, `产品口径待确认`
- `实际结果`
- `证据附件`
- `证据路径`
- `是否产生写入`: `无写入`, `已写入且已恢复`, `已写入待恢复`, `写入被拦截`
- `恢复说明`
- `关联任务`
- `执行人`: `alex`, `kt`, `Codex`, `Claude`, `人工测试`
- `执行时间`
- `下次动作`: `无需处理`, `补证据`, `提 Bug`, `待后端确认`, `修复后复测`, `纳入门禁`
- `回流豁免原因`

Filling requirements:

- `失败`, `阻塞`, and `部分通过` execution results must either link/create a `任务看板` row via `关联任务`, or provide a clear `回流豁免原因`.
- Test-run bugs should flow back to `任务看板`, not remain only in `测试执行记录`.
- If `是否产生写入 = 已写入待恢复`, fill `恢复说明` and make sure the row appears in the write-recovery view.
- Evidence-light rows should be caught by the `证据不足` view; add a screenshot, interface response, console output, local report path, or explicit reason.

#### Read-Back Checks For This Profile

After writing task/test-case data, inspect the relevant views before reporting success:

- Task import/update: `产品总览`, `Bug 修复池`, `待优化池`, `Bug 未派生用例`, `P0/P1 待测`.
- Case import/update: `全部用例`, `Bug 派生回归`, `发布门禁`, `长期复测池`, `待补全`.
- Execution import/update: `最近执行`, `失败/阻塞`, `Bug 回流待处理`, `写流待恢复`, `证据不足`.

If these views expose missing links, missing evidence, missing recovery notes, or missing test-case derivation, fix the data before calling the update complete.

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
- linked-record write ability when syncing task-board tasks to test cases or execution records
- batch record create/update ability when importing multiple task-derived cases
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

## Test Case Repository Mode

Use test-case mode when the user asks to:

- pull suitable task-board bugs or optimizations into a test-case table
- create or maintain a long-lived test-case repository
- maintain release-gate, bug-derived, needs-completion, or long-not-retested views
- create test execution records for a real run
- make failed/blocked execution results flow back into the task board

Preferred Base shape:

- `任务看板` or project-equivalent backlog table: source of bugs, optimizations, refactors, and requirements.
- `测试用例` or project-equivalent case repository: long-lived "how to test" records.
- `测试执行记录` or project-equivalent run/result table: per-run "what happened this time" records.

Do not collapse the case repository and execution history into one table unless the project explicitly uses that model. A test case is a reusable standard; an execution record is one run's evidence.

### Task Board To Test Case Import

When importing from the task board:

- Import every confirmed `Bug` as at least one regression case, including closed historical bugs when recurrence would be costly.
- Import `待优化` only when it touches a core user flow, cross-role consistency, data correctness, permission/session behavior, write protection, mobile/browser compatibility, or export/copy accuracy.
- Do not automatically import low-risk visual polish, broad refactors, or unconfirmed new requirements. Keep them in PM/product validation until the acceptance rule is clear.
- One task usually maps to one case for the first pass, but split into multiple cases when the bug clearly has separate admin-side, teacher-side, backend/API, compatibility, or cross-side sync risks.
- Link the case to the source task with the configured linked-record field. Text task numbers are useful in titles/notes but are not a substitute for the link.
- Use the task's priority to map to the case's priority, but translate labels into the case table's configured options. For example, a task P0 usually maps to a case P0/core and release-gate or fix-required coverage.
- Preserve missing sample requirements. If the task still lacks campus, course, teacher, student, device, browser, screenshot, or final business wording, set the case status to needs-info/project equivalent instead of pretending it is executable.
- After case creation is read back, update the task board test-case status to the configured generated/pending-execution value. Do not mark it passed/covered without a current execution record.

Typical first-pass inclusion table:

| Task type | First-pass action |
|---|---|
| Bug | Import as regression case. |
| Closed historical bug | Import as regression case when recurrence matters. |
| P0/P1 optimization | Import only if core flow, data, permission/session, write protection, cross-role sync, compatibility, or export/copy accuracy is affected. |
| P2/P3 polish | Leave in PM validation unless the user explicitly asks to cover it. |
| Refactor | Wait for design/acceptance criteria, or create a pending-design case only for known no-regression invariants. |
| New requirement | Wait for acceptance criteria and implementation stage. |

Recommended test-case fields:

| Meaning | Notes |
|---|---|
| Case id | Stable, human-readable id; task-derived cases may include the source task id. |
| Case title | Start with regression/acceptance wording, not raw bug text. |
| Source type | Task bug derived, core flow, historical regression, release gate, compatibility, API contract, exploratory finding, or project terms. |
| Source task link | Linked-record field to the task board. Required for task-derived cases. |
| Module | Login/session, teacher attendance, admin attendance/control, temporary students, substitute/class merge/swap, course settings, time/copy, compatibility, security/permissions, or project terms. |
| Role scope | Admin side, teacher side, cross-side, multi-campus admin, external teacher, backend/API, or project terms. |
| Case priority | P0/P1/P2/P3 or project terms. |
| Gate level | Release must-run, fix must-run, weekly/monthly regression, on demand, or project terms. |
| Retest frequency | Every release, related module change, after bug fix, weekly, monthly, or on demand. |
| Environment | shared dev, internal test, production, static artifact, code review, or project terms. |
| Write-flow risk | Read-only, low-risk recoverable write, high-risk write needs confirmation, code-only, or project terms. |
| Preconditions | Required account, campus, course, sample data, device, browser, or date. |
| Steps | Actionable manual or automation steps. |
| Expected result | Observable pass condition. |
| Evidence requirement | Screenshot, API response, console, clipboard summary, git status, report path, or project terms. |
| Automation candidate | Already automated, suitable for automation, manual only, unknown, or project terms. |
| Case status | Pending design, executable, needs info, paused, deprecated, or project terms. |
| Latest result/time | Manual or lookup/formula-backed summary; do not use this as the execution history. |

Read back after import:

- all-case count
- bug-derived view count
- release-gate view count
- needs-info/needs-completion view count
- task-board missing-case view count
- high-priority pending-test task view count

Record the counts in the final report and in repo-local quality docs when the project rules require test-source or case-count tracking.

### Test Execution Record Mode

Use execution records only for actual test runs.

Execution records should include:

- execution id/batch
- linked case
- execution type, environment, role, campus/scope, business object, and execution time
- actual result: pass, fail, blocked, partial, not run, not applicable, or project terms
- actual steps summary when it differs from the standard case
- evidence path or approved attachment
- owner/attribution: frontend, backend, data, permission, environment, test account, product wording, or project terms
- write-impact flag and recovery note for write-flow tests
- linked task for failures, blocked runs, partial passes, or known issues
- backflow exemption reason only when a failure does not need a task

Rules:

- Do not create execution records while only drafting/importing cases.
- Do not overwrite a case with a run result; create an execution record.
- Failed, blocked, or partial execution records must link to an existing task, create a new task if the project/user allows, or include a backflow exemption reason.
- Write-flow tests must record whether data was changed, restored, or left pending recovery.
- Execution records are not a substitute for repo-local quality reports when the project requires dated history docs.

Useful views:

- current run
- failed/blocked
- failed execution awaiting task backflow
- write pending recovery
- bug-fix retest
- release regression records
- backend/product-confirmation needed
- insufficient evidence

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
lark-cli base +record-list --base-token "<base-token>" --table-id "<table-id>" --field-id "<field-name>" --limit 200 --format json --as user
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

For test-case import and execution-record maintenance:

```bash
lark-cli base +record-list --base-token "<base-token>" --table-id "<task-table-id>" --field-id "<task-title>" --field-id "<task-type>" --field-id "<task-priority>" --field-id "<test-case-status>" --limit 200 --format json --as user
lark-cli base +record-list --base-token "<base-token>" --table-id "<case-table-id>" --field-id "<case-id>" --field-id "<case-title>" --field-id "<source-task-link>" --limit 200 --format json --as user
lark-cli base +record-batch-create --base-token "<base-token>" --table-id "<case-table-id>" --json '{"fields":["<case-id>","<case-title>","<source-task-link>"],"rows":[["TC-001","Regression: ...",[{"id":"rec_xxx"}]]]}' --as user
lark-cli base +record-batch-update --base-token "<base-token>" --table-id "<task-table-id>" --json '{"record_id_list":["rec_xxx"],"patch":{"<test-case-status>":"<pending-execution-option>"}}' --as user
lark-cli base +record-upsert --base-token "<base-token>" --table-id "<execution-table-id>" --json '{"<execution-id>":"RUN-001","<linked-case>":[{"id":"rec_case"}],"<result>":"失败","<linked-task>":[{"id":"rec_task"}]}' --as user
```

Linked-record fields use arrays of record ids such as `[{"id":"rec_xxx"}]`. Resolve the real record ids by reading the source table; do not guess them from task numbers.

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
- selected mode: push ledger, task board, test-case sync, test execution record, dashboard/view maintenance, attachment sync, or draft-only
- branch and commit SHA, when code sync was involved
- Feishu record id/number, task count, case count, execution-record count, view/dashboard names, or draft-only status
- docs referenced for counterpart review
- verification actually run, with failures or skipped checks
- screenshot/evidence batch path and whether attachments were uploaded
- dashboard or view read-back result when the work changed dashboards/views
- test-case read-back counts when cases changed: all cases, bug-derived cases, release-gate cases, needs-completion cases, task-board missing-case count, and high-priority pending-test count when configured
- authorization, scope, or missing-policy blockers

Keep the report short and distinguish local docs, repo-visible docs, Feishu records, pushed code, deployed code, task board state, dashboards/views, attachments, and live verification.
