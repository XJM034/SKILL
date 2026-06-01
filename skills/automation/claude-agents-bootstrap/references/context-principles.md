# Context Principles

Use these principles when shaping `CLAUDE.md` and `AGENTS.md`.

## Human steers, agents execute

- Use root docs to preserve human decisions about intent, risk, acceptance
  criteria, and handoff boundaries.
- Give agents enough repo-local routes to execute without requiring pasted
  chat context.
- Treat agent difficulty as a signal that a tool, doc, constraint, or feedback
  loop may be missing.

## Root documents

- Treat root instruction docs as resident context, not as full knowledge bases.
- Keep only stable, high-frequency rules in root docs.
- Prefer short, concrete rules over explanatory prose.
- Make root docs a map to deeper truth, not the deeper truth itself.

## Progressive disclosure

- Push low-frequency or bulky detail into supporting docs.
- Organize supporting docs by module or concern so they can be loaded on demand.
- Add a routing document when multiple supporting docs exist.
- Treat plans, decision logs, design docs, tech-debt trackers, and generated
  references as first-class artifacts when the repo already uses them.
- When a supporting doc is an active queue, such as backend coordination,
  quality issues, blockers, bugs, or tech debt, define its lifecycle: active
  criteria, completion evidence, archive destination, and when to ask a human.

## Repo as record system

- Prefer versioned repo artifacts over external memory. Code, Markdown,
  schemas, generated references, executable plans, and tests are discoverable by
  future agents.
- If a durable decision lives in chat, Slack, a ticket, or a handoff note, move
  it into an appropriate repo document before relying on it as future context.
- Handoff notes can restore continuity, but root docs should still tell agents
  to verify important claims against repo evidence.
- Code history, handoff notes, conversation context, and long-term memory can
  help decide whether an active queue item is stale or completed, but uncertain
  or conflicting evidence should trigger a focused user question before the doc
  is rewritten.

## Agent readability

- Optimize for what a future agent can inspect, validate, and modify directly.
- Route agents to package scripts, CI jobs, lint rules, structure tests, local
  dev commands, browser QA tools, logs, metrics, tracing, and generated schema
  docs when they exist.
- Avoid instructions that require hidden human knowledge, unversioned tools, or
  manual copy-paste from external systems unless they are explicitly labeled as
  external assumptions.

## Noise control

- Optimize for information density, not maximum token count.
- Do not preserve long logs, grep dumps, or tool output in instruction docs.
- Avoid placing unstable details in root docs if they are likely to change.

## Executable guardrails

- Prefer mechanically enforced invariants over prose-only rules.
- Document where a rule is enforced: lint, tests, CI, scripts, types, schemas,
  package boundaries, or review automation.
- If a rule is important but not enforced, label it as a convention or gap so a
  future agent does not mistake it for a hard boundary.
- Encode repair hints in custom checks when possible so failing tools teach the
  next agent how to recover.

## Verification

- If a fact can be checked in code, verify it before writing it as a rule.
- If the user wants a target-state rule that differs from current code, label it
  clearly as intent versus current reality before drafting.
- For UI or runtime claims, prefer runnable validation surfaces: local previews,
  browser automation, screenshots, logs, metrics, or traces.

## Feedback loops

- Convert repeated review comments, bugs, and cleanup work into durable docs,
  tests, lint rules, scripts, or quality checks.
- Treat recurring agent mistakes as missing system structure, not as one-off
  prompt failures.
- Include update routes for "quality principles" so subjective preferences can
  become repeatable checks over time.

## Entropy management

- Expect agent-generated systems to copy existing patterns, including weak ones.
- Route drift cleanup into small recurring maintenance work instead of rare
  large rewrites.
- Include doc-gardening or stale-doc checks when the repo has enough structure
  to support them.
- Prefer "current queue + history/archive" over ever-growing current docs; stale
  items should be released when evidence is sufficient, not left to accumulate
  until a human manually prunes them.

## Archiving

- When moving large content out of root docs, archive it first.
- Date-stamp archives so later audits can tell when the split happened.

## Compression

- Always include compact instructions in root docs.
- Prefer compact instructions that preserve:
  - confirmed architecture and business rules
  - modified files and key changes
  - validation results
  - open risks and pending work

## Update rules

- Document where future changes should be written.
- Make update routing specific enough that later sessions do not guess.
