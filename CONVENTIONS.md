# GTD + Zettelkasten System

## Directory Structure

```
<vault-root>/
├── gtd/
│   ├── inbox/                 # Unprocessed items
│   ├── next-actions/items/    # Active tasks
│   ├── next-actions/done/     # Completed tasks
│   ├── projects/items/        # Active projects
│   ├── projects/done/         # Completed projects
│   ├── waiting-for/           # Waiting items
│   ├── someday-maybe/         # Someday/Maybe
│   ├── reference/             # Reference materials
│   └── daily-logs/            # Daily logs, weekly reviews, morning pages
├── zettelkasten/
│   ├── permanent/             # Permanent notes (ideas in your own words)
│   ├── literature/            # Literature notes (summaries of external sources)
│   └── fleeting/              # Fleeting notes
└── templates/                 # Obsidian templates
```

## Naming Conventions

| Note Type | Filename Pattern | Location |
|---|---|---|
| Inbox item | `YYYYMMDD-HHmmss-<slug>.md` | `gtd/inbox/` |
| Next Action | `YYYYMMDD-<slug>.md` | `gtd/next-actions/items/` |
| Project | `YYYYMMDD-<slug>.md` | `gtd/projects/items/` |
| Daily log | `YYYY-MM-DD.md` | `gtd/daily-logs/` |
| Morning page | `YYYY-MM-DD-morning-page.md` | `gtd/daily-logs/` |
| Weekly review | `YYYY-MM-DD-weekly-review.md` | `gtd/daily-logs/` |
| Permanent note | `YYYYMMDD-<slug>.md` | `zettelkasten/permanent/` |
| Literature note | `YYYYMMDD-<slug>.md` | `zettelkasten/literature/` |

- `<slug>`: alphanumeric with hyphens, Japanese OK (keep short and concise)

## Frontmatter Conventions

All notes require YAML frontmatter.

```yaml
# inbox
---
type: inbox
captured: 2024-01-01T09:00:00
source: manual  # manual | url
---

# next-action
---
type: next-action
project: "[[Project Name]]"
context: "@pc"  # @pc, @phone, @office, @home, @errand, @anywhere
energy: medium  # low, medium, high
estimated-time: 30min  # 5min, 15min, 30min, 1h, 2h, half-day
due: 2024-01-15
created: 2024-01-01
---

# project
---
type: project
status: active  # active, on-hold, completed
outcome: "Expected outcome in one sentence"
created: 2024-01-01
---

# zettel (permanent note)
---
type: zettel
tags:
  - thinking
  - leadership
created: 2024-01-01
---

# literature note
---
type: literature
source: "URL or book title"
author: "Author name"
tags:
  - tech
created: 2024-01-01
---

# daily-log
---
type: daily-log
date: 2024-01-01
energy: 3  # 1-5
---

# morning-page
---
type: morning-page
date: 2024-01-01
---

# weekly-review
---
type: weekly-review
date: 2024-01-01
---

# insights
---
type: insights
date: 2024-01-01
period: 30
period_start: 2024-01-01
period_end: 2024-01-30
---
```

## Link Conventions

- Use Obsidian Wikilink format `[[Note Name]]`
- Permanent notes (zettel) must have a `## Connections` section with links to related notes
- Bidirectional links: `/gz:zettel` command sets up backlinks automatically

## Commands

| Command | Description |
|---|---|
| `/gz:init` | Initial vault setup |
| `/gz:capture` | Quick capture to Inbox |
| `/gz:inbox` | Process Inbox items via GTD decision tree |
| `/gz:morning` | Daily log generation + action plan |
| `/gz:zettel` | Co-create permanent notes with bidirectional links |
| `/gz:research` | Create literature notes from URL/topic |
| `/gz:review` | Weekly review (system health check) |
| `/gz:insights` | Analyze daily log trends and patterns |
| `/gz:commit` | Git commit & push |
