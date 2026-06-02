---
name: session-to-skill-and-blog
description: >
  Turn a completed non-trivial engineering session into a paired durable
  artifact: (1) a reusable skill committed and pushed to the configured GitHub
  skill repo, and (2) a blog post published to MX Space and surfaced by the
  Alex Notes frontend.
  Triggers on "把这个过程写成 skill 再写一篇 blog"、"沉淀一下这次的折腾"、
  "productize this session"、"publish this as a skill and a writeup".
metadata:
  author: minxian
  version: "0.9.0"
---

# session-to-skill-and-blog

Capture a hard-won session as a **pair**: an operational skill (durable
artifact) and a narrative blog (discoverability layer linking to it). On this
machine, the canonical skill repo is GitHub, the blog backend is MX Space on
Railway, and the public frontend is Alex Notes on Vercel:

```text
https://github.com/XJM034/SKILL
https://alex-notes-phi.vercel.app
```

## When to use

Use when the session had ≥ 1 non-obvious pitfall, a novel workflow worth
keeping, or the user said "写成 skill / productize this". Skip for pure
interactive Q&A or project-specific lessons (those go in the project's
`CLAUDE.md`).

## Iron rule: skill first, blog second

The blog needs a real skill reference. For this personal setup, that reference
must be a GitHub URL in the user's own public skill repo:

```text
https://github.com/XJM034/SKILL/tree/main/skills/<domain>/<skill-name>
```

Do not invent a GitHub URL. If the skill is only local, keep the blog as a draft
until the skill has been pushed and the GitHub URL returns 200. SKILL.md's
format forces operational completeness before narrative drama distorts the
lessons.

## Configuration

`~/.config/innei-skills/config.json` (see `references/config.example.json`):

```json
{
  "skill_repo_dir": "~/.codex/skill-first-assets",
  "skill_repo_public_url": "https://github.com/XJM034/SKILL/tree/main"
}
```

Codex local install also supports
`~/.codex/config/innei-skills/config.json`; on this machine it is already set
to `~/.codex/skill-first-assets`. Missing key → fallback to
`~/.codex/skill-first-assets`. For one-off tests, `INNEI_SKILL_REPO_DIR`
overrides both config files.

Blog/MX Space target is configured by:

```text
~/.codex/config/innei-skills/mxs.env
```

Current profile:

```text
MXS_PROFILE=railway-mx-space
```

The Vercel frontend project lives at:

```text
~/.codex/skill-first-assets/cloud-mx-space/frontend
```

The local skill repo tracks:

```text
origin https://github.com/XJM034/SKILL.git
```

Generated skills always live in the GitHub-backed skill repo first:

```text
~/.codex/skill-first-assets/skills/<domain>/<skill-name>/SKILL.md
```

That repo is the system of record and must be pushed to GitHub before the blog
step. Codex local slash-menu installation is optional convenience only:

```text
~/.codex/skills/<skill-name> -> ~/.codex/skill-first-assets/skills/<domain>/<skill-name>
```

Before installing that optional local symlink, ask the user whether they want
this new skill available via Codex `/`. If yes, pass `--install-codex` to the
scaffold script. Codex usually loads the slash/skill menu at session start, so a
fresh session may still be needed after installation.

## Available domains

`infrastructure` / `automation` / `writing` / `research` / `content`

## Scripts

All operational steps below call into this skill's own `scripts/`. Define
`$S` once per session, then drive the workflow with one-liners:

```bash
S="$(realpath ~/.claude/skills/session-to-skill-and-blog)/scripts"
# Codex: swap ~/.claude for ~/.codex
```

| Script                  | What it does                                                                                    |
| ----------------------- | ----------------------------------------------------------------------------------------------- |
| `resolve-skill-repo.sh` | Print absolute path to the SKILL repo (config-driven, with fallback).                           |
| `scaffold-skill.sh`     | Create dir + stub SKILL.md + README row + repo symlinks; optionally install a Codex local symlink. |
| `publish-skill.sh`      | Stage, commit, push, and verify the public GitHub URL for a skill.                              |
| `load-litexml.sh`       | `degit` the latest `litexml-authoring` subtree (SKILL.md + `references/`) into `~/.cache/`.     |
| `publish-post.sh`       | `mxs post create` as draft, with `aiGen=2`, `--open` admin preview, `--silent` response.        |
| `get-post.sh`           | `mxs post get <slug> --output xml` — round-trip step 1.                                         |
| `update-post.sh`        | `mxs post update <slug> --file …` — round-trip step 2.                                          |

Prereqs once per machine: `npm i -g @mx-space/cli` (Node ≥ 22); `mxs auth login`.

## Workflow

```text
[1] Inventory session
[2] Scaffold + author SKILL.md
[3] Publish skill to GitHub
[4] Write blog
[5] Publish via mxs
[6] Verify Alex Notes frontend
```

### [1] Inventory

Scan the session for: decision points, pitfalls (symptom → cause → fix),
inline code ≥ 15 lines (extract → `scripts/`), JSON/YAML ≥ 20 lines
(extract → `references/` with `<PLACEHOLDER>` markers), verification
commands, "I was wrong about X" moments (alert callouts in the blog).

### [2] Scaffold + author

Ask the user one small routing question before scaffolding:

```text
Do you also want this skill installed into Codex local `/` discovery?
```

If yes:

```bash
bash "$S/scaffold-skill.sh" --install-codex <domain> <skill-name> "<one-line purpose>"
```

If no or unclear:

```bash
bash "$S/scaffold-skill.sh" <domain> <skill-name> "<one-line purpose>"
```

Fill in the stub. SKILL.md sections in order: frontmatter (`name`,
`description` starting "Use when…", ≤ 500 chars) → overview → scope →
inputs → files provided → workflow ASCII → per-step → **Common Pitfalls
table** (mandatory) → rules → verification checklist. Target ≤ 250 lines.

The scaffold always writes the skill into:

```text
~/.codex/skill-first-assets/skills/<domain>/<skill-name>
```

and stages the skill files, README row, and repo loader symlinks. With
`--install-codex`, it also creates:

```text
~/.codex/skills/<skill-name>
```

as a symlink for future Codex sessions.

### [3] Publish skill to GitHub

```bash
bash "$S/publish-skill.sh" <domain> <skill-name>
```

This script stages the skill, README row, and repository symlinks; commits;
pushes to GitHub; then verifies the public URL.

If `publish-skill.sh` fails at commit, push, or URL verification, stop before
writing/publishing the blog. The blog must not pretend the skill is public. Fix
auth/remote first.

Verify the GitHub URL:

```bash
curl -I "https://github.com/XJM034/SKILL/tree/main/skills/<domain>/<skill-name>"
```

Skill URL (used twice in the blog — top banner + bottom CTA):

```text
https://github.com/XJM034/SKILL/tree/main/skills/<domain>/<skill-name>
```

### [4] Write the blog

**Voice: pick one of two personas.** Decide by what the blog is actually
about: the *process* or the *thing*.

| Persona                   | Use when                                                                                                            | "I" refers to |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------- | ------------- |
| `agent` first-person      | The blog narrates a session/dogfood run — symptom → investigation → fix → why (e.g. the nextjs → react-router post) | the agent     |
| `site-owner` first-person | The blog is about a tool, workflow, format, or system that the site owner designed and owns                         | the site owner |

Selection rule: if the main subject is a *process the agent went through*,
use `agent`. If the main subject is a *thing the site owner built* (CLI, format,
workflow, infra), use `site-owner`. Writing in agent voice when the
ownership is the site owner's misattributes the design labor to the executor.

When the post needs both (the site owner's design intent plus a dogfood run that
exposed an issue), stay in `site-owner` voice and refer to the agent in
third person, e.g. "an agent run surfaced X, so I fixed Y". Do not switch
personas mid-post.

#### `site-owner` style — Willison + Abramov + Antirez

When writing in `site-owner` persona, combine three reference styles. Each
contributes a distinct property; together they keep the prose honest,
structured, and assertive.

- **Willison transparency.** Show your work. Quote real error output, commit
  hashes, exact version numbers, the actual file path you edited. No mystery,
  no hand-waving. Link to source liberally. When something failed, say so —
  including which approach you tried first and why it didn't work.
- **Abramov arc.** Each section has setup → tension → payoff. Open with an
  observation, a constraint, or a question. Build the reader's expectation.
  Then resolve. Use concrete examples to drive abstract points, not the other
  way around. The reader should feel they're discovering something *with*
  you, not being lectured at.
- **Antirez 断语.** Short, declarative sentences for conclusions. No
  hedging. "X is wrong." "Y works." "Don't do Z." Stand-alone lines that
  carry the weight of a decision. Use them at section breaks and at the end
  of paragraphs that earn them.

#### Punctuation

- **Em-dashes (——) sparingly.** The default punctuation is `。` `，` `：` `；`
  or parentheses. Reserve `——` for genuine asides, mid-sentence
  interruptions, or true em-dash thought-jumps. A row of em-dashes in close
  succession reads as lazy structure.
- Prefer two short sentences over one long sentence joined by an em-dash.
- Use `：` to introduce a list, example, or definition.
- Use `（）` for parenthetical asides that are tightly bound to the surrounding
  sentence.
- Quote tag names and code identifiers in `<code>...</code>`, not `「...」`.

#### Visuals

Prefer Excalidraw over Mermaid in `site-owner` posts. The hand-drawn feel
matches the personal voice, and Excalidraw is more flexible for the kinds
of diagrams `site-owner` posts tend to need:

| Diagram type                       | Use         | Why                                                            |
| ---------------------------------- | ----------- | -------------------------------------------------------------- |
| Decision tree / branching choice   | Excalidraw  | Diamond + labeled branches reads cleaner than Mermaid          |
| Architecture lanes (named columns) | Excalidraw  | Lane backgrounds with title + bullet body are highly readable  |
| Timeline / event chain             | Excalidraw  | Vertical spine + color-coded entries beats a Mermaid gantt     |
| Pipeline (linear N-step flow)      | Excalidraw  | Boxes + arrows in a row, hand-drawn rectangles feel right      |
| Strict sequence diagram            | Mermaid     | When precise actor lifelines + ordered messages are required   |
| Dense flowchart with many edges    | Mermaid     | Auto-routing handles edge crossings better                     |

Embed Excalidraw inline as `<excalidraw><![CDATA[{...scene JSON...}]]></excalidraw>`.
Use the canonical color palette (light blue / light purple / light yellow /
light green / light pink). Position text elements explicitly; do not rely
on auto-centering across blog renderers.

For `site-owner` posts of any substance, **aim for at least three Excalidraw
diagrams** — one for the high-level pipeline, one for the architecture
overview, one for the most important decision or chain narrated in prose.
More is fine. Use Mermaid only when the diagram type column above says so.

**Structure:** opening (task + sub-tasks + top URL banner) → one section
per "act" mirroring the skill's steps → each act follows symptom →
investigation → fix → why → closing (skill tree listing + bottom URL CTA).

**Medium:** default LiteXML for MX Space. Load authoring guide:

```bash
LITEXML_CACHE=$(bash "$S/load-litexml.sh")
# Read $LITEXML_CACHE/SKILL.md and references/{authoring-recipes,cli,
# nodes-structural,nodes-extensions}.md as needed.
```

Plain Markdown is fine when no haklex-specific tags (`<alert>`, `<grid>`,
`<details>`, …) are needed. Preview the rendered article:

```bash
mxs preview /tmp/blog/article.xml
```

`mxs preview` is envelope-aware: it strips the `<mxpost>` / `<mxnote>`
wrapper, auto-detects `--variant`, and opens the HTML in the system
browser by default. Pass `--print` to dump to stdout, `--save <path>` to
write a file without opening.

### [5] Publish via `mxs`

```bash
mxs auth status                      # confirm; if not, mxs auth login
mxs category list --output llm       # MUST reuse an existing category slug
cp "$(dirname "$S")/references/envelope.template.xml" /tmp/blog/article.xml
# edit envelope: fill <title>/<slug>/<category>/<tags>, paste LiteXML body
bash "$S/publish-post.sh" /tmp/blog/article.xml
# Preview in the admin tab opened by --open; when the user approves:
mxs post publish <slug> --profile railway-mx-space
```

Edits (round-trip):

```bash
bash "$S/get-post.sh"   <slug> > /tmp/blog/article.xml
# edit
bash "$S/update-post.sh" <slug> /tmp/blog/article.xml
```

### [6] Verify Alex Notes frontend

The public blog URL is the Vercel frontend, not the Railway API root:

```text
https://alex-notes-phi.vercel.app
```

After publishing, verify:

```bash
curl -sS https://mx-core-production.up.railway.app/api/v3/posts | rg "<slug>|is_published"
curl -I https://github.com/XJM034/SKILL/tree/main/skills/<domain>/<skill-name>
curl -I https://alex-notes-phi.vercel.app
curl -fsS https://alex-notes-phi.vercel.app/posts/ | rg "<slug>|Latest notes"
curl -fsS https://alex-notes-phi.vercel.app/posts/<slug>/ | rg "<title>|article-page"
curl -fsS https://alex-notes-phi.vercel.app/search.json | rg '"slug":"<slug>"'
```

Then open `https://alex-notes-phi.vercel.app` and `/posts/`. The root route is
a standalone personal homepage, so it only needs to show the new post in
Recent Writing when the post is among the latest entries. The durable proof is:
`/posts/` lists the post, `/posts/<slug>/` renders the article, and
`/search.json` contains the slug.

For posts that include MX Space rich content, Lexical nodes, or Excalidraw
diagrams, the frontend article page is the proof surface. MX Space admin preview
can render correctly while Alex Notes still leaks raw payloads if the frontend
renderer is stale. In that case, explicitly check the public article body does
not expose raw renderer data:

```bash
curl -fsS https://alex-notes-phi.vercel.app/posts/<slug>/ | rg -i "<excalidraw|CDATA|\"elements\"|Excalidraw Whiteboard" && exit 1 || true
```

Then visually open `/posts/<slug>/` and confirm each Excalidraw block appears as
a white embedded canvas with working pan/zoom controls, not as JSON, CDATA, or
literal XML tags.
Paste the final Alex Notes URL and skill URL back into the originating session
as the asset-ization receipt.

## Common pitfalls

| Mistake                                              | Fix                                                                                  |
| ---------------------------------------------------- | ------------------------------------------------------------------------------------ |
| Blog before skill                                    | Skill first. Always.                                                                 |
| SKILL.md too long (all code inline)                  | Extract ≥ 15-line code to `scripts/`. Target ≤ 250 lines.                            |
| Picking a persona by reflex instead of subject       | Process narrative → `agent`. Owned tool/format/workflow → `site-owner`. Apply the selection rule. |
| Switching personas mid-post                          | Pick one and stay. If both are needed, keep `site-owner` voice and refer to the agent in third person. |
| Pitfalls in prose only, no table                     | Pitfalls table is mandatory; it's the most-grep'd section.                           |
| Skill URL not embedded in blog (both top + bottom)   | Banner at top, CTA at bottom.                                                        |
| Treating local Codex `/` install as mandatory        | Ask the user. GitHub publish is mandatory; Codex local symlink is optional.           |
| Using `Innei/SKILL` for this personal blog           | Use `XJM034/SKILL` unless the user explicitly provides another owned repo.            |
| Using Vercel file URLs as canonical skill links      | Vercel displays the blog; GitHub is the canonical skill source.                       |
| Expecting `/` to hot-reload a newly installed skill  | Even when installed locally, Codex may only refresh skills on a new session.          |
| Saying "published to Vercel" literally               | Posts are published to MX Space; Vercel displays the public posts API.                |
| `--no-verify` to bypass pre-commit hook              | Pre-commit invariants must all be in the same commit; fix the root cause instead.    |
| Hardcoding `~/git/innei-repo/skill` in shell         | `bash "$S/resolve-skill-repo.sh"` — config-driven with fallback.                     |
| Stale local `litexml-authoring` clone                | `bash "$S/load-litexml.sh"` refreshes via degit on every call.                       |
| `pnpm --silent litexml …` from a haklex worktree     | `mxs preview <file>` — envelope-aware, no local clone, opens browser by default.     |
| Skill written in Chinese                             | Skill in English (artifact). Blog in the user's chosen language (default Chinese).   |
| `--state publish` on `post create`                   | Always create as draft. `mxs post publish <slug>` only after the user approves preview. |
| Re-running `post create` to edit                     | Round-trip: `get-post.sh` → edit → `update-post.sh`.                                 |
| LiteXML body passed straight to `mxs --file`         | Wrap in `references/envelope.template.xml` first.                                    |
| Hand-writing `<summary>`                             | Omit. Server AI auto-generates and may overwrite.                                    |
| Picking `<category>` without checking what exists    | `mxs category list --output llm` first; reuse existing slug.                         |
| Auto-creating a new category                         | Requires explicit second confirmation from the user before `mxs category create`.    |
| Forgetting `aiGen=2`                                 | `publish-post.sh` already passes `--meta '{"aiGen":2}'`; on first update of a legacy post, re-attach with `mxs post update <slug> --meta '{"aiGen":2}'`. |
| Trusting MX Space admin preview alone                | Verify Alex Notes `/posts/<slug>/` too. Frontend renderer bugs can leak raw `<excalidraw>`, `CDATA`, or JSON even when MX Space admin looks correct. |

## Verification

- [ ] `bash "$S/resolve-skill-repo.sh"` resolves before any write.
- [ ] Skill dir at `$REPO/skills/<domain>/<skill-name>/`; long code in
      `scripts/`, long configs in `references/`.
- [ ] SKILL.md has frontmatter + scope + inputs + workflow + **pitfalls
      table** + verification checklist.
- [ ] Ask whether to install into Codex local `/`; if yes, run scaffold with
      `--install-codex` and verify `~/.codex/skills/<skill-name>` symlink.
- [ ] `bash "$S/publish-skill.sh" <domain> <skill-name>` succeeded.
- [ ] Skill URL resolves from `https://github.com/XJM034/SKILL/tree/main/skills/...`; embedded in blog at top + bottom.
- [ ] Blog voice picks `agent` or `site-owner` per the selection rule and
      stays in that persona throughout; previews cleanly via `mxs preview`.
- [ ] For `site-owner` posts: Willison transparency (real errors / commits /
      paths quoted), Abramov arc (setup → tension → payoff per section),
      Antirez 断语 (short declarative conclusions). Em-dashes used sparingly.
      At least three Excalidraw diagrams.
- [ ] `mxs auth status` returned the expected user/profile.
- [ ] `<category>` reuses an existing slug (or the user explicitly approved
      a new one).
- [ ] Envelope `<state>draft</state>` on first push; `mxs post publish
      <slug> --profile railway-mx-space` only after the user approves.
- [ ] `aiGen=2` set on the post (via `publish-post.sh` at create, or
      `mxs post update --meta` on first edit of a legacy post).
- [ ] Alex Notes frontend shows the public post in `/posts/`, renders
      `/posts/<slug>/`, and includes the slug in `/search.json`; root may show
      only the latest entries because it is now a standalone homepage.
- [ ] Rich content / Excalidraw posts render cleanly in Alex Notes: no raw
      `<excalidraw>`, `CDATA`, JSON `elements`, or `Excalidraw Whiteboard`
      placeholder leaks in `/posts/<slug>/`.
- [ ] Final post URL and skill URL pasted back into the originating session.
