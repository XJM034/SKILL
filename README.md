# Personal Skills Repository

This repository stores personal AI agent skills in a scalable directory layout.
Each skill is a small operational playbook that can be reused by Codex, Claude
Code, or another agent runner.

## Layout

```text
SKILL/
├── README.md
├── skills/
│   ├── infrastructure/
│   ├── automation/
│   ├── writing/
│   ├── research/
│   └── content/
│       └── <skill-name>/
│           ├── SKILL.md
│           ├── references/   (optional)
│           ├── scripts/      (optional)
│           └── assets/       (optional)
├── .agent/skills/<skill-name>  -> ../../skills/<domain>/<skill-name>
├── .claude/skills/<skill-name> -> ../../skills/<domain>/<skill-name>
└── templates/
    ├── SKILL.template.md
    └── SKILL.with-references.template.md
```

## Conventions

- Place real skills only under `skills/`.
- Group skills by stable domains: `infrastructure`, `automation`, `writing`,
  `research`, or `content`.
- Each skill owns one directory with one required `SKILL.md`.
- Optional `references/`, `scripts/`, and `assets/` folders should exist only
  when they materially improve reuse.
- Keep `templates/` for skeletons only. Templates are not active skills.
- Avoid credentials, tokens, personal account data, phone numbers, and one-time
  coordination details.
- Use lowercase kebab-case directory names.
- Keep project names out of domain folders; put reusable behavior into the skill
  body instead.

### Infrastructure

> Deployment, servers, databases, containers, observability.

| Skill | Purpose |
| ----- | ------- |

### Automation

> Repeated CLI procedures, browser workflows, and agent operating playbooks.

| Skill | Purpose |
| ----- | ------- |
| [`chrome-live-business-qa`](skills/automation/chrome-live-business-qa/SKILL.md) | Run visible Chrome QA for live multi-role business apps without corrupting data |
| [`session-to-skill-and-blog`](skills/automation/session-to-skill-and-blog/SKILL.md) | Turn hard-won sessions into GitHub-backed skills and Alex Notes blog posts |

### Writing

> Structured writing, publishing, and editorial workflows.

| Skill | Purpose |
| ----- | ------- |

### Research

> Data analysis, report generation, and evidence mining.

| Skill | Purpose |
| ----- | ------- |

### Content

> Site-specific publishing, media, and asset workflows.

| Skill | Purpose |
| ----- | ------- |

## Agent Integration

Skills are exposed to agents through flat symlinks:

```text
.agent/skills/<skill-name>  -> ../../skills/<domain>/<skill-name>
.claude/skills/<skill-name> -> ../../skills/<domain>/<skill-name>
```

Do not symlink the whole `skills/` directory. Many agent loaders only discover
skills one level below their configured `skills/` folder.

## Adding a New Skill

1. Create `skills/<domain>/<skill-name>/`.
2. Copy a template from `templates/` into that directory as `SKILL.md`.
3. Fill in frontmatter, scope, workflow, pitfalls, rules, and verification.
4. Move long code into `scripts/`; move long config/examples into `references/`.
5. Add one README row under the matching domain.
6. Add flat symlinks under `.agent/skills/` and `.claude/skills/`.
7. Commit and push before writing the blog post that links to the skill.

## Repository Hooks

Enable the local hook after cloning:

```bash
git config core.hooksPath .githooks
```

The hook checks that every skill has a README row and matching flat symlinks.
