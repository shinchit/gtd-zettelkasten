# GTD + Zettelkasten for Claude Code

[日本語版はこちら](./README.ja.md)

A productivity system combining GTD (Getting Things Done) and Zettelkasten note-taking, implemented as a Claude Code plugin. Manage tasks, build knowledge, and plan your day — all from the CLI.

## Install

```
/plugin marketplace add https://github.com/shinchit/gtd-zettelkasten.git
/plugin install gz@gz
```

## Setup

Run the init command to set up your vault:

```
/gz:init
```

This will:
- Create the GTD directory structure (`gtd/inbox/`, `gtd/next-actions/`, etc.)
- Create the Zettelkasten directory structure (`zettelkasten/permanent/`, etc.)
- Copy Obsidian templates
- Add conventions to your `CLAUDE.md`
- Create `.claude/config.local.md` for personal settings

## Personal Configuration

Edit `.claude/config.local.md` to configure:

- **Calendar**: gcalcli path and calendar names for `/gz:morning`
- **Slack**: Enable/disable notifications (set `SLACK_WEBHOOK_URL` in `.env`)
- **GitHub**: Assignee and target repositories for issue/PR queries

## Commands

| Command | Description |
|---|---|
| `/gz:init` | Initial vault setup |
| `/gz:capture <memo or URL>` | Quick capture to Inbox |
| `/gz:inbox` | Process Inbox items via GTD decision tree |
| `/gz:morning` | Daily log + calendar + GitHub + action plan |
| `/gz:daily-log` | End-of-day reflection + task completion + Three Good Things |
| `/gz:zettel [topic]` | Co-create permanent notes with bidirectional links |
| `/gz:research <URL or topic>` | Create literature notes from research |
| `/gz:review` | Weekly review — full system health check |
| `/gz:insights [days]` | Analyze daily log trends (energy, tasks, patterns) |
| `/gz:commit` | Git commit & push with auto-generated message |

## Recommended Daily Workflow

### Morning (5-10 min)

```
/gz:morning
```

Start your day here. This single command:
- Creates a **daily log** with today's date
- Writes a **morning page** — free-form thoughts to clear your mind
- Pulls your **calendar** (via gcalcli) and **GitHub** issues/PRs
- Scans your **Next Actions** and suggests a prioritized action plan
- Identifies **gaps in your schedule** for deep work

The morning page is private and never analyzed by other commands. Use it to dump whatever is on your mind — worries, ideas, plans, complaints. This mental offloading helps you focus for the rest of the day.

### During the Day

**Capture everything, decide nothing (yet).**

```
/gz:capture Buy new monitor for home office
/gz:capture https://interesting-article.com
```

Whenever a thought, task, or URL comes to mind, capture it immediately. Don't stop to categorize — just get it out of your head and into the Inbox. This is the core GTD principle: your brain is for having ideas, not holding them.

**Process when you have a break.**

```
/gz:inbox
```

When you have 10-15 minutes between tasks, process your Inbox. Each item goes through the GTD decision tree:
- **Actionable?** → Next Action or Project
- **2-minute rule** → Do it now, then delete
- **Not actionable** → Reference, Someday/Maybe, or Trash

**Turn insights into knowledge.**

```
/gz:zettel
/gz:research https://some-article.com
```

Had an interesting realization during work? Use `/gz:zettel` to write it as a permanent note in your own words, with links to related ideas. Found a useful article? `/gz:research` creates a structured literature note.

### End of Day (5 min)

```
/gz:daily-log
```

Close your day with a quick reflection:
1. **Task review** — Mark each recommended action as done, carry over, delete, or move to Someday
2. **Three Good Things** — Name 3 positive moments from today (builds gratitude habit)
3. **Notes** — Any observations or learnings
4. **Tomorrow** — What do you want to tackle first? (feeds into tomorrow's `/gz:morning`)
5. **Rating** — Rate your day 1-5

Completed tasks automatically move from `next-actions/items/` to `next-actions/done/`, preserving your history.

```
/gz:commit
```

Commit and push everything. Your entire productivity system is version-controlled.

### Weekly (20-30 min)

Pick a consistent day (e.g., Friday afternoon or Sunday evening).

```
/gz:review
```

The weekly review walks you through every part of your system:
- **Inbox** — Any stragglers?
- **Projects** — Still active? Have next actions? Stalled?
- **Next Actions** — Overdue? Still relevant?
- **Waiting-for** — Need to follow up?
- **Someday/Maybe** — Time to promote anything?
- **Zettelkasten** — Orphan notes? Missing backlinks?

```
/gz:insights
```

After a few weeks of daily logs, this gets really valuable. See your energy trends, find your best/worst days, spot carry-over tasks that need to be broken down or dropped.

### Tips

- **Morning page honesty** — Nobody reads it but you. The more honest, the more useful.
- **Capture liberally, process ruthlessly** — Low friction in, high standards out.
- **One next action per project** — If a project has no next action, it's stalled. The weekly review catches this.
- **Energy-aware scheduling** — `/gz:morning` considers your energy level when suggesting actions. Be honest about it.
- **Let insights accumulate** — `/gz:insights` becomes more powerful over time. The patterns it surfaces (e.g., "low energy every Wednesday") can change how you structure your week.

## Directory Structure

```
your-vault/
├── gtd/
│   ├── inbox/                 # Unprocessed items
│   ├── next-actions/items/    # Active tasks
│   ├── next-actions/done/     # Completed tasks
│   ├── projects/items/        # Active projects
│   ├── projects/done/         # Completed projects
│   ├── waiting-for/           # Waiting items
│   ├── someday-maybe/         # Someday/Maybe
│   ├── reference/             # Reference materials
│   └── daily-logs/            # Daily logs, reviews, morning pages
├── zettelkasten/
│   ├── permanent/             # Your ideas in your own words
│   ├── literature/            # Summaries of external sources
│   └── fleeting/              # Quick temporary notes
└── templates/                 # Obsidian templates
```

## Requirements

- [Claude Code](https://claude.com/claude-code) CLI
- [gh](https://cli.github.com/) (GitHub CLI) — for `/gz:morning` and `/gz:review`
- [gcalcli](https://github.com/insanum/gcalcli) (optional) — for calendar integration
- [jq](https://jqlang.github.io/jq/) — for Slack notifications
- [Playwright](https://playwright.dev/) (optional) — for JS-rendered URL fetching

## Acknowledgements

This project was inspired by the article [「考える」から「判断する」へ、Claude Codeを中心に置いたタスク・ナレッジ管理](https://dev.classmethod.jp/articles/ai-driven-gtd-zettelkasten/) by [kinjo-shuya](https://dev.classmethod.jp/author/kinjo-shuya/) at Classmethod. The article describes building a GTD + Zettelkasten productivity system powered by Claude Code, which became the foundation for this plugin.

## License

MIT
