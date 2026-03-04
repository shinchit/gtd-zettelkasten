# GTD + Zettelkasten for Claude Code

GTD（Getting Things Done）とZettelkasten式ノート術を組み合わせた生産性システムを、Claude Code プラグインとして提供します。タスク管理・知識構築・1日の計画をCLIから実行できます。

## インストール

```
/plugin marketplace add https://github.com/shinchit/gtd-zettelkasten.git
/plugin install gz@gz
```

## セットアップ

init コマンドで Vault を初期セットアップします:

```
/gz:init
```

以下が自動実行されます:
- GTD ディレクトリ構造の作成（`gtd/inbox/`, `gtd/next-actions/` 等）
- Zettelkasten ディレクトリ構造の作成（`zettelkasten/permanent/` 等）
- Obsidian テンプレートのコピー
- `CLAUDE.md` への規約追記
- `.claude/config.local.md`（個人設定ファイル）の作成

## 個人設定

`.claude/config.local.md` を編集して環境に合わせてください:

- **Calendar**: gcalcli のパスとカレンダー名（`/gz:morning` で使用）
- **Slack**: 通知の有効/無効（Webhook URL は `.env` の `SLACK_WEBHOOK_URL` に設定）
- **GitHub**: Issue/PR 検索時の assignee および対象リポジトリ

## コマンド一覧

| コマンド | 説明 |
|---|---|
| `/gz:init` | Vault の初期セットアップ |
| `/gz:capture <メモ or URL>` | Inbox にアイテムを素早くキャプチャ |
| `/gz:inbox` | Inbox アイテムを GTD 意思決定ツリーで振り分け |
| `/gz:morning` | 日報生成 + カレンダー + GitHub + アクションプラン |
| `/gz:daily-log` | 終業時の振り返り + タスク完了確認 + Three Good Things |
| `/gz:zettel [トピック]` | 永続ノートの共同作成（双方向リンク付き） |
| `/gz:research <URL or トピック>` | URL/トピックから文献ノート作成 |
| `/gz:review` | 週次レビュー（システム全体の健全性チェック） |
| `/gz:insights [日数]` | 日報データの傾向分析（エネルギー推移・タスク・曜日パターン等） |
| `/gz:commit` | Git commit & push（コミットメッセージ自動生成） |

## ワークフロー

### 毎日

1. `/gz:morning` — 日報生成、スケジュール確認、アクションプラン提案
2. `/gz:capture` — 日中のアイデアやタスクをキャプチャ
3. `/gz:inbox` — 時間のあるときに Inbox を処理
4. `/gz:daily-log` — 終業時の振り返り、タスク完了・繰り越し確認、Three Good Things
5. `/gz:commit` — 1日の終わりに変更をコミット

### 毎週

1. `/gz:review` — GTD リスト全体と Zettelkasten の健全性を包括チェック
2. `/gz:insights` — エネルギー推移・タスク完了率・曜日パターン等の傾向分析

### 随時

- `/gz:research` — トピックや URL を調査して文献ノートを作成
- `/gz:zettel` — アイデアや気づきから永続ノートを作成

## ディレクトリ構造

```
your-vault/
├── gtd/
│   ├── inbox/                 # 未処理アイテム
│   ├── next-actions/items/    # アクティブなタスク
│   ├── next-actions/done/     # 完了タスク
│   ├── projects/items/        # アクティブプロジェクト
│   ├── projects/done/         # 完了プロジェクト
│   ├── waiting-for/           # 待ち項目
│   ├── someday-maybe/         # いつかやる
│   ├── reference/             # 参考資料
│   └── daily-logs/            # 日報・週次レビュー・モーニングページ
├── zettelkasten/
│   ├── permanent/             # 永続ノート（自分の言葉で書いた知見）
│   ├── literature/            # 文献ノート（外部ソースの要約）
│   └── fleeting/              # 一時メモ
└── templates/                 # Obsidian テンプレート
```

## フロントマター規約

すべてのノートは YAML フロントマター必須です。詳細は [CONVENTIONS.md](./CONVENTIONS.md) を参照してください。

### 主なノートタイプ

```yaml
# Inbox アイテム
type: inbox
captured: 2024-01-01T09:00:00
source: manual  # manual | url

# Next Action
type: next-action
project: "[[プロジェクト名]]"
context: "@pc"       # @pc, @phone, @office, @home, @errand, @anywhere
energy: medium       # low, medium, high
estimated-time: 30min  # 5min, 15min, 30min, 1h, 2h, half-day
due: 2024-01-15

# プロジェクト
type: project
status: active  # active, on-hold, completed
outcome: "期待する成果を1文で"

# 永続ノート
type: zettel
tags: [thinking, leadership]

# 文献ノート
type: literature
source: "URL or 書籍名"
author: "著者名"
```

## 必要なツール

| ツール | 用途 | 必須 |
|---|---|---|
| [Claude Code](https://claude.com/claude-code) | CLI 本体 | 必須 |
| [gh](https://cli.github.com/) | GitHub Issue/PR 確認 | 必須 |
| [gcalcli](https://github.com/insanum/gcalcli) | カレンダー連携 | 任意 |
| [jq](https://jqlang.github.io/jq/) | Slack 通知の JSON 生成 | Slack 使用時 |
| [Playwright](https://playwright.dev/) | JS レンダリングが必要な URL 取得 | 任意 |

## 謝辞

本プラグインは、Classmethod の [kinjo-shuya](https://dev.classmethod.jp/author/kinjo-shuya/) さんによる記事「[「考える」から「判断する」へ、Claude Codeを中心に置いたタスク・ナレッジ管理](https://dev.classmethod.jp/articles/ai-driven-gtd-zettelkasten/)」に着想を得ています。Claude Code を活用した GTD + Zettelkasten の実践手法を詳しく解説した同記事が、このプラグインの基盤となりました。

## ライセンス

MIT
