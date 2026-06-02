---
name: handoff
description: |
  Create a dated handoff markdown file for the next AI agent when the current
  session is getting too long, the user wants to continue in a fresh
  conversation, or work must be transferred without relying on full chat
  history. Use when Codex should summarize current task state, progress,
  constraints, findings, remaining work, risks, and recommended next steps into
  `./handoff/YYMMDD-handoff.md` or a user-specified handoff file.
metadata:
  author: minxian
  version: "0.1.0"
---

# Handoff

## Goal

Write a high-signal handoff document for the next AI agent.

Assume the next agent cannot access the full current conversation and may only
see the handoff file. Optimize for fast continuation, not for user-facing
polish.

## Workflow

1. Determine the output path.
   - Default to `./handoff/YYMMDD-handoff.md` using the local current date in
     `yymmdd` format.
   - Create the `./handoff/` folder if it does not already exist.
   - If the user specifies a different path, use that path and create its parent
     folder if needed.
   - If the dated handoff file already exists, replace it with a fresh handoff
     unless the user explicitly asks to append.

2. Reconstruct the current state before writing.
   - Use the current thread, repo state, modified files, recent checks, and
     produced artifacts.
   - Verify critical file paths, commands, module names, and decision points
     before citing them.
   - Distinguish clearly between:
     - confirmed facts
     - reasonable inferences
     - unresolved assumptions

3. Write for the next AI agent, not for the user.
   - Be direct and concrete.
   - Prefer exact file paths, commands, APIs, routes, classes, modules, tables,
     environment variables, and decisions over generic prose.
   - Do not add pleasantries, reassurance, or retrospective commentary.
   - Do not dump raw logs unless a specific fragment is needed to unblock the
     next step.

4. Use this exact structure.

```md
# Handoff

## 1. 当前任务目标
[当前要解决的问题、预期产出、完成标准]

## 2. 当前进展
[已完成的分析、确认、修改、排查、讨论或产出]

## 3. 关键上下文
- [重要背景信息]
- [用户的明确要求]
- [已知约束]
- [已做出的关键决定]
- [重要假设]

## 4. 关键发现
- [最重要的结论、规律、异常点、根因判断、设计判断]

## 5. 未完成事项
1. [最高优先级待办]
2. [次高优先级待办]

## 6. 建议接手路径
- 优先查看：[文件、模块、日志、命令、页面、线索]
- 先验证：[需要先确认的事实或风险点]
- 推荐动作：[最合理的下一步]

## 7. 风险与注意事项
- [容易误判、重复劳动或跑偏的点]
- [已验证过且不建议继续的方向]

下一位 Agent 的第一步建议：
[给出一个最具体、最值得立刻执行的第一步]
```

5. Fill every section with concrete content.
   - Prefer specific references over summary prose.
   - Rank unfinished work by actual continuation value.
   - Call out known dead ends so the next agent does not repeat them.
   - If something is uncertain, label it as uncertain instead of overstating it.

6. Verify the output before finishing.
   - Confirm the handoff folder and file exist at the intended path.
   - Confirm all seven numbered sections are present.
   - Confirm the final paragraph `下一位 Agent 的第一步建议` exists.
   - Confirm the document reads like an internal baton pass, not a user update.

## Guardrails

- Do not ask follow-up questions unless a missing answer would materially change
  the handoff or the user explicitly asked for a custom path.
- Do not produce a user-facing summary instead of the file.
- Do not write default handoff files to the repo root; use `./handoff/` unless
  the user explicitly provides a custom path.
- Do not omit concrete names if they are available.
- Do not hide disagreement between user intent and current code; record it
  explicitly as a risk or unresolved point.
- Do not leave the next agent guessing which files or commands matter most.

## Common pitfalls

| Mistake | Fix |
| ------- | --- |
| Writing a user-facing recap instead of an internal baton pass | Write for the next agent, with exact paths, commands, decisions, risks, and first step. |
| Hiding uncertainty | Separate confirmed facts, reasonable inferences, and unresolved assumptions. |
| Forgetting to verify the artifact shape | Confirm the file exists, all seven numbered sections are present, and the final first-step paragraph exists. |
| Reusing stale thread memory as fact | Verify critical paths, commands, module names, and decisions before citing them. |

## Verification checklist

- [ ] The intended `handoff/YYMMDD-handoff.md` or custom path exists.
- [ ] The file includes sections `1` through `7` exactly as specified.
- [ ] The final `下一位 Agent 的第一步建议` paragraph exists.
- [ ] The document distinguishes confirmed facts, inferences, and unresolved assumptions.
- [ ] The prose reads like an internal baton pass, not a user-facing progress update.
