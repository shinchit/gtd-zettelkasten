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

## おすすめの1日の使い方

### 朝（5〜10分）

```
/gz:morning
```

1日はここから始めます。このコマンド1つで:
- 今日の**日報**を作成
- **モーニングページ**を記録 — 頭の中を自由に書き出す時間
- **カレンダー**（gcalcli）と **GitHub** の Issue/PR を取得
- **Next Actions** をスキャンし、優先度付きのアクションプランを提案
- スケジュールの**空き時間**を見つけて活用を提案

モーニングページはプライベートなもので、他のコマンドが分析することはありません。不安、アイデア、計画、愚痴、何でも書き出してください。この「脳内の棚卸し」が、その日の集中力を高めてくれます。

### 日中

**すべてキャプチャ、判断は後回し。**

```
/gz:capture 新しいモニターを買う
/gz:capture https://interesting-article.com
```

タスク・思いつき・URL が頭に浮かんだら、即座にキャプチャ。分類は後でやります。これが GTD の核心: 脳はアイデアを「生む」ためにあり、「覚えておく」ためにあるのではない。

**隙間時間に Inbox を処理。**

```
/gz:inbox
```

タスクの合間に 10〜15分あれば、Inbox を処理します。各アイテムを GTD の意思決定ツリーに沿って振り分けます:
- **アクション可能？** → Next Action or プロジェクト化
- **2分ルール** → 今すぐやって、完了したら削除
- **アクション不可** → 参考資料 / いつかやる / 不要なら削除

**気づきを知識に変える。**

```
/gz:zettel
/gz:research https://some-article.com
```

仕事中に面白い気づきがあれば `/gz:zettel` で永続ノートに。自分の言葉で書き、既存のノートとリンクすることで知識のネットワークが育ちます。気になる記事があれば `/gz:research` で文献ノートに。

### 終業時（5分）

```
/gz:daily-log
```

短い振り返りで1日を締めくくります:
1. **タスク確認** — 朝の Recommended Actions を1つずつ確認（完了 / 繰り越し / 削除 / Someday）
2. **Three Good Things** — 今日よかったこと3つ（小さなことでOK。感謝の習慣づくり）
3. **Notes** — 気づきやメモ
4. **Tomorrow** — 明日やりたいこと（翌朝の `/gz:morning` に引き継がれます）
5. **Rating** — 今日の評価（1〜5）

完了したタスクは `next-actions/items/` → `next-actions/done/` に自動移動し、履歴として残ります。

```
/gz:commit
```

すべてコミット & プッシュ。生産性システム全体が Git でバージョン管理されます。

### 毎週（20〜30分）

決まった曜日（例: 金曜の夕方、日曜の夜）に実施します。

```
/gz:review
```

週次レビューでシステム全体を点検します:
- **Inbox** — 未処理アイテムはないか？
- **プロジェクト** — まだアクティブ？Next Action はあるか？停滞していないか？
- **Next Actions** — 期限切れは？まだ有効？
- **Waiting-for** — フォローアップが必要？
- **Someday/Maybe** — 今やるべきものは？
- **Zettelkasten** — 孤立ノートや片方向リンクはないか？

```
/gz:insights
```

日報が数週間分たまると、本領を発揮します。エネルギーの推移、曜日パターン、繰り越し常連タスクなど、データから傾向を読み取れます。

### Tips

- **モーニングページは正直に** — 誰も読みません。正直に書くほど効果があります。
- **キャプチャは気軽に、処理は厳しく** — Inbox に入れるハードルは低く、振り分けの基準は高く。
- **1プロジェクトに1つの Next Action** — Next Action がないプロジェクトは停滞しています。週次レビューで検出されます。
- **エネルギーを意識したスケジューリング** — `/gz:morning` はエネルギーレベルを考慮してアクションを提案します。正直に申告しましょう。
- **インサイトは蓄積させる** — `/gz:insights` は時間とともに強力になります。「毎週水曜にエネルギーが低い」などのパターンが、1週間の組み立て方を変えてくれます。

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
