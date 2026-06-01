---
name: claude-agents-bootstrap
description: |
  Evidence-first workflow for creating, regenerating, or refactoring project
  instruction docs such as CLAUDE.md and AGENTS.md. Use when starting a
  repository, replacing bloated root guidance, auditing whether current
  instruction docs match the codebase, or setting up a context-management
  scheme with short root docs, on-demand supporting docs, archive rules,
  update rules, compact instructions, agent-readable tooling maps, executable
  guardrails, and feedback loops. The skill consumes the user's provided
  context and repo evidence, asks focused questions only when needed, confirms
  assumptions, then writes the docs.
---

# Claude Agents Bootstrap

## Goal

Produce lean, durable project instruction docs that follow the context-management
principles from the Tw93 Claude Code article: reduce noise, keep root docs short,
push detail into on-demand references, and preserve removed detail in archives.
Also apply agent-first collaboration principles from OpenAI's harness engineering
article: treat root docs as maps, treat the repo as the durable record system,
make important context agent-readable, and prefer executable feedback loops over
prose-only guidance.

Set lifecycle goals for supporting docs that act as active collaboration queues
such as backend coordination, quality gates, bug trackers, tech-debt lists, or
release blockers. These docs should not silently become long-term backlogs:
root docs should route agents to the queue, define when items are added, define
when completed items can be released to history/archive, and tell agents to ask
the user a focused question when evidence is insufficient or conflicting.

Use this skill to gather the missing policy decisions from the user, verify what
is already true in the repo, and only then generate or update `CLAUDE.md` and
`AGENTS.md`.

## Core Rules

- Optimize for noise reduction, not maximum length.
- Keep root docs short, hard, and executable. Prefer under 120 lines unless the
  project genuinely needs more.
- Unless the user explicitly requests another language, generate `CLAUDE.md`
  and `AGENTS.md` in Simplified Chinese.
- Put only stable, session-critical rules in root docs:
  - project contract
  - load map
  - commands
  - validation expectations
  - update rules
  - compact instructions
  - hard prohibitions
- Move low-frequency detail into supporting docs such as `docs/AI_REFERENCE.md`,
  `docs/ai/*.md`, `docs/md/security/*`, or `docs/sql/*`.
- If long root content is removed, archive it before deleting it.
- Mirror `AGENTS.md` to `CLAUDE.md` unless the user explicitly wants a divergence.
- Never codify an implementation claim that has not been verified in code or
  explicitly confirmed by the user.
- Treat human responsibility as steering: intent, prioritization, acceptance
  criteria, and risk decisions. Treat agent responsibility as execution through
  repo-local tools, docs, scripts, and validation loops.
- Treat the versioned repo as the primary record system for future agents. If a
  stable policy or decision exists only in chat, a handoff, a tracker, or a
  person's memory, route it into an appropriate repo document or mark it as an
  external assumption.
- Prefer executable guardrails over prose-only warnings. When an invariant can
  be enforced by lint, tests, CI, scripts, types, schema checks, or review
  automation, document the enforcement path or record the missing guardrail as a
  gap.
- Optimize generated docs for agent readability: point agents to commands,
  logs, browser QA hooks, observability surfaces, generated schemas, plans, and
  other artifacts they can inspect directly.
- Capture repeated review comments, user bugs, or cleanup patterns as document
  updates, tests, lint rules, helper scripts, or explicit quality checks.
- When supporting docs are active queues, define their lifecycle explicitly:
  what qualifies as active, what evidence can mark an item complete, where
  completed items are archived, and when an agent must ask instead of guessing.
- Treat code timeline, handoff notes, current conversation context, and
  available long-term memory as useful evidence for queue cleanup, but still
  verify claims against repo/runtime evidence when possible and label uncertain
  memory-derived facts.
- Generated root docs must explicitly tell future fresh-session agents that, if
  they are continuing prior work, they should read the latest handoff note
  produced by `$handoff` in `./handoff/` by default, or in the
  user-provided handoff path, as supplemental context while still verifying key
  claims against the repo.
- Generated root docs must also explicitly tell future agents when they should
  rerun `$claude-agents-bootstrap` to refresh `CLAUDE.md`, `AGENTS.md`, and
  directly related supporting docs.
- If the user has already provided enough background to draft safely, do not ask
  filler questions just to follow a questionnaire.
- If user intent and current code differ, state the mismatch plainly and ask
  whether the docs should describe current reality or intended target state.

Read `references/context-principles.md` before drafting any generation,
refactor, or audit. It is concise and contains the durable principles that
should shape the output.

## Workflow

1. Establish scope.
   - Confirm whether the task is:
     - first-time creation
     - cleanup/refactor of existing docs
     - audit only
     - migration from long root docs to layered docs
   - If the user did not specify a target, assume the deliverables are
     `CLAUDE.md` and `AGENTS.md` plus any minimal supporting docs needed to keep
     the roots lean.
   - If the user did not specify a document language, default to Simplified
     Chinese for generated root docs.

2. Build the minimum repo context.
   - Read only the smallest useful file set first:
     - existing `CLAUDE.md` / `AGENTS.md`
     - `README.md`
     - `docs/README.md` or `docs/AI_REFERENCE.md` if present
   - Then inspect code to verify the highest-risk facts:
     - roles and route boundaries
     - auth and session model
     - database/source-of-truth docs
     - upload/export/security boundaries
     - commands and verification expectations
   - Look for agent-readable operating surfaces:
     - package scripts, task runners, and local dev commands
     - CI jobs, lint rules, structure tests, and custom validators
     - browser/UI QA instructions, screenshots, recordings, or preview commands
     - logs, metrics, tracing, generated schema docs, or observability docs
     - active plans, completed plans, tech-debt trackers, and handoff notes
   - Do not invent missing surfaces. Classify them as gaps or user-confirmed
     targets before writing them as instructions.

3. Decide whether questions are needed.
   - Start from the information the user already provided plus the minimum repo
     evidence you verified.
   - If that information is sufficient to draft safely, skip questioning and
     move directly to the confirmation checkpoint.
   - Ask one short question at a time only for high-impact gaps that the repo
     cannot answer and the user has not already covered.
   - Do not ask for facts that are already obvious from the repo unless the
     answer is a policy choice.
   - Use `references/intake-checklist.md` to decide what to ask next.
   - Stop asking once the remaining gaps are not material to drafting safely.

4. Normalize every answer into a document rule.
   - After each answer, classify it as one of:
     - user-confirmed policy
     - code-verified fact
     - still-open assumption
     - executable guardrail
     - documented gap
   - If a user answer conflicts with the code, surface the exact mismatch and ask
     for the intended documentation stance before writing.
   - For each important rule, decide whether the final docs should:
     - keep it resident in the root docs
     - route to a supporting doc
     - point to an existing command, lint, test, CI job, or script
     - call out a missing enforcement gap
   - For supporting docs that manage active work such as backend coordination,
     quality issues, bugs, release blockers, or tech debt, decide the lifecycle
     rule:
     - active queue criteria
     - completion evidence sources
     - history/archive destination
     - when an agent may clean up without asking
     - when uncertainty requires a focused user question before editing
   - Plan the handoff guidance that will be written into the generated root
     docs.
   - Plan the bootstrap-refresh guidance that will be written into the generated
     root docs.
   - By default, generated `CLAUDE.md` / `AGENTS.md` should:
     - mention the latest `./handoff/*-handoff.md` file or a user-provided
       handoff path in `first-read files`, `load map`, or `work style`
     - explain that handoff notes supplement, but do not replace, code checks
     - include explicit rerun triggers for `$claude-agents-bootstrap`
   - Default rerun triggers should include:
     - changes to roles, permissions, route boundaries, auth, or session model
     - changes to database source-of-truth docs, schema references, or security
       boundaries
     - changes to upload, export, storage, commands, validation flow, or
       document structure
     - completion of a large feature branch, preparation for handoff, or
       preparation for merge / PR when the current docs may no longer match the
       code
   - Only omit this guidance if the user explicitly says the project should not
     use handoff notes between sessions.

5. Build a confirmation checkpoint before editing.
   - Summarize:
     - confirmed facts
     - unresolved assumptions
     - proposed root-doc sections
     - proposed supporting-doc split
     - proposed agent-readable tooling and validation map
     - important guardrails that are enforced versus prose-only
     - known documentation or enforcement gaps
     - output language for generated docs
     - the exact handoff guidance the generated root docs will include for fresh
       sessions
     - the exact rerun triggers the generated root docs will include for
       `$claude-agents-bootstrap`
   - Ask the user to confirm the summary or correct it.
   - Do not edit files until the user has explicitly confirmed the high-impact
     facts or accepted the remaining assumptions.

6. Write the docs.
   - Root docs should usually include:
     - purpose
     - first-read files
     - commands
     - load map
     - agent-readable tooling map
     - fresh-session handoff guidance
     - bootstrap refresh guidance
     - stable constraints
     - enforced guardrails and known gaps
     - supporting-doc lifecycle rules for active queues
     - document update rules
     - validation rules
     - never rules
     - compact instructions
   - Unless the user explicitly requested another language, write the generated
     `CLAUDE.md` and `AGENTS.md` in Simplified Chinese.
   - Unless the user explicitly opts out, the handoff guidance in generated
     root docs should say:
     - if a fresh session starts after prior work, check the newest
       `./handoff/*-handoff.md` file or the handoff path provided by the user
     - treat the handoff note as supplemental context, not as a replacement for
       repo verification
   - Unless the user explicitly requests a different policy, generated root
     docs should also say to rerun `$claude-agents-bootstrap` when:
     - AI guidance no longer matches the code after major implementation work
     - route / auth / permission / schema / storage / export / security
       boundaries change
     - document structure, commands, or validation expectations change
     - a large feature branch finishes, a handoff is about to happen, or a PR /
       merge is being prepared
   - Supporting docs should be organized by module or concern, not by arbitrary
     prose chunks.
   - If the refactor changes document locations, update indexes such as
     `docs/README.md`.

7. Run a documentation-specific regression pass.
   - Scan active docs for stale paths, contradictory rules, and outdated source
     of truth references.
   - Confirm local markdown links resolve.
   - Confirm `CLAUDE.md` and `AGENTS.md` remain mirrored if mirroring was chosen.
   - Confirm generated docs distinguish enforced guardrails from prose-only
     conventions.
   - Confirm any durable external context needed by future agents is either
     moved into repo docs or explicitly labeled as external.

## Questioning Protocol

Only ask questions when the current information set is not enough to draft
safely. When questions are needed, ask the next most important unanswered one
from this order:

1. What is the intended scope of the docs?
2. Should `AGENTS.md` mirror `CLAUDE.md` exactly?
3. What are the project's real role and route boundaries?
4. What is the actual auth/session model?
5. What should count as database/source-of-truth references?
6. Which details belong in root docs versus supporting docs?
7. Which invariants are enforced by tooling versus only documented?
8. Which agent-readable surfaces should future sessions use for QA, logs,
   observability, plans, and generated references?
9. Which future code changes must update which docs?
10. What commands and validation steps are mandatory?
11. What compacted context must always survive summarization?

Keep the question style compact:

- one question per turn
- concrete, not theoretical
- phrased to force a decision when a policy choice is needed
- anchored to current repo evidence when possible
- never ask a question that the user has already answered well enough
- keep asking only until the remaining gaps are immaterial to safe drafting
- before editing, switch from questions to a short confirmation summary and wait
  for explicit approval

## Output Contract

When the skill completes successfully, it should usually produce:

- `CLAUDE.md`
- `AGENTS.md`
- optional `docs/AI_REFERENCE.md`
- optional `docs/ai/*.md`
- optional `docs/README.md` updates
- optional date-stamped archive files under `docs/md/archive/`

The final docs should reflect these article-derived outcomes:

- root docs are short enough to stay resident
- low-frequency detail is reachable but not resident
- generated root docs are written in Simplified Chinese unless the user opted
  into another language
- fresh sessions are explicitly told to read handoff notes from `./handoff/`
  by default to recover context
- future agents are explicitly told when to rerun `$claude-agents-bootstrap`
- update rules route future changes to the right file
- active queues have explicit add/complete/archive rules, so they do not grow
  forever as stale backlogs
- compact instructions preserve the right facts during summarization
- agent-readable operating surfaces are discoverable from the roots or a routed
  supporting doc
- enforced guardrails are distinguished from conventions and known gaps
- repeated bugs, review feedback, and cleanup patterns have an update route
- removed detail is archived, not silently dropped

## Resources

- Read `references/context-principles.md` for the condensed context-management
  principles that drive the document shape.
- Read `references/intake-checklist.md` when deciding what to ask or whether the
  current information set is sufficient to draft safely.
