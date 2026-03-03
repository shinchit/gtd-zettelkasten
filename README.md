# GTD + Zettelkasten for Claude Code

[日本語版はこちら](./README.ja.md)

A productivity system combining GTD (Getting Things Done) and Zettelkasten note-taking, implemented as a Claude Code plugin. Manage tasks, build knowledge, and plan your day — all from the CLI.

## Install

```
/plugin marketplace add <repo-url>
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
- **GitHub**: Assignee for issue/PR queries

## Commands

| Command | Description |
|---|---|
| `/gz:init` | Initial vault setup |
| `/gz:capture <memo or URL>` | Quick capture to Inbox |
| `/gz:inbox` | Process Inbox items via GTD decision tree |
| `/gz:morning` | Daily log + calendar + GitHub + action plan |
| `/gz:zettel [topic]` | Co-create permanent notes with bidirectional links |
| `/gz:research <URL or topic>` | Create literature notes from research |
| `/gz:review` | Weekly review — full system health check |
| `/gz:commit` | Git commit & push with auto-generated message |

## Workflow

### Daily

1. `/gz:morning` — Generate daily log, review schedule, plan actions
2. `/gz:capture` — Capture ideas and tasks throughout the day
3. `/gz:inbox` — Process inbox when you have time
4. `/gz:commit` — Commit changes at end of day

### Weekly

1. `/gz:review` — Comprehensive review of all GTD lists and Zettelkasten health

### As Needed

- `/gz:research` — Research a topic or URL, create literature notes
- `/gz:zettel` — Develop permanent notes from your ideas and insights

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

This project was inspired by the article [「考える」から「判断する」へ、Claude Codeを中心に置いたタスク・ナレッジ管理](https://dev.classmethod.jp/articles/ai-driven-gtd-zettelkasten/) by shinchi.takahiro at Classmethod. The article describes building a GTD + Zettelkasten productivity system powered by Claude Code, which became the foundation for this plugin.

## License

MIT
