# Intake Checklist

Use this checklist to decide what to inspect and whether anything still needs to
be asked.

## 1. Scope

- Is this first-time creation, cleanup, or audit?
- Are `CLAUDE.md` and `AGENTS.md` both in scope?
- Should supporting docs also be created or only the root docs?

## 2. Repo facts to verify in code

- role and route boundaries
- auth/session model
- database and schema sources of truth
- storage, upload, export, and security boundaries
- canonical developer commands
- current document tree
- existing lint, test, CI, type, schema, and structure checks
- local preview, browser QA, screenshot, log, metric, tracing, or observability
  surfaces agents can use directly
- generated references, design docs, active plans, completed plans, tech-debt
  trackers, and handoff conventions
- active queues such as backend coordination, quality issues, blockers, bug
  lists, or tech-debt lists, including whether they have history/archive rules
- doc freshness checks, link checks, or doc-gardening automation

## 3. Policy questions for the user

Ask only when the repo cannot answer them safely and the user has not already
provided enough direction.

- Should `AGENTS.md` mirror `CLAUDE.md` exactly?
- Should the generated root docs use a language other than the default
  Simplified Chinese?
- What should the root docs treat as source of truth when docs and code differ?
- What rerun triggers should the generated root docs define for
  `$claude-agents-bootstrap`?
- What future changes must trigger doc updates?
- What details should remain resident in root docs?
- What should always survive compaction?
- Which bulky details should be moved to supporting docs?
- Which supporting docs are active queues, and what evidence lets agents move
  completed items to history/archive without asking?
- When evidence about an active queue item is insufficient or conflicting, what
  focused question should agents ask before editing?
- Which human preferences or quality principles should become repeatable
  guardrails?
- Which important rules are currently conventions only, and should the docs
  label them as gaps?
- Which external systems, if any, are acceptable as required context for future
  agents?

## 4. Red flags

Stop and clarify before drafting if you see any of these:

- current docs describe intended future behavior, not current code
- multiple docs claim to be the single source of truth
- root docs contain module encyclopedias
- supporting docs exist but the root docs do not route to them
- the user wants policy statements that conflict with live code
- docs rely on chat, tickets, or handoff notes as source truth without routing
  durable decisions back into the repo
- current issue/backlog docs keep accumulating completed items and have no
  explicit add/complete/archive lifecycle
- root docs list important prohibitions that no tool enforces and do not label
  them as conventions or gaps
- runtime or UI validation is required but no agent-readable validation surface
  is documented
- repeated bugs or review comments have no route into docs, tests, lint, or
  helper scripts

## 5. Done criteria

You have enough information when all of these are true:

- root-doc scope is clear
- major route and auth boundaries are verified
- source-of-truth files are identified
- doc update routing is defined
- active queue lifecycle routing is defined for add, complete, archive, and
  ask-when-uncertain cases
- agent-readable tooling and validation surfaces are mapped or explicitly
  called out as missing
- enforced guardrails are distinguished from prose-only conventions and known
  gaps
- durable external context has either been moved into repo docs or labeled as an
  external assumption
- compact instructions are defined
- the generated root docs are in Simplified Chinese unless the user explicitly
  requested another language
- the generated root docs explicitly tell fresh sessions to read handoff notes
  created by `$handoff` in `./handoff/` by default as supplemental context,
  unless the user explicitly opted out
- the generated root docs explicitly define when future agents should rerun
  `$claude-agents-bootstrap`
- any migrated long content has an archive destination
- the user has confirmed the final fact summary or explicitly accepted any
  remaining assumptions
- no remaining question would materially change the safe draft
