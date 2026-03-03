---
description: Vault の初期セットアップ（ディレクトリ作成・テンプレートコピー・CLAUDE.md 設定）
allowed-tools: [Read, Write, Edit, Glob, Grep, Bash]
---

Obsidian Vault を GTD + Zettelkasten システムとして初期セットアップするコマンド。

## 手順

### 1. ディレクトリ構造の作成

以下のディレクトリを作成する（既に存在する場合はスキップ）:

```
gtd/
├── inbox/
├── next-actions/items/
├── next-actions/done/
├── projects/items/
├── projects/done/
├── waiting-for/
├── someday-maybe/
├── reference/
└── daily-logs/
zettelkasten/
├── permanent/
├── literature/
└── fleeting/
templates/
```

各ディレクトリに `.gitkeep` を配置して空ディレクトリを Git 管理対象にする。

### 2. テンプレートのコピー

プラグインの `templates/` ディレクトリから以下のテンプレートをプロジェクトの `templates/` にコピーする:

- `next-action.md`
- `project.md`
- `zettel.md`
- `literature.md`
- `daily-log.md`
- `morning-page.md`

既にファイルが存在する場合は上書き確認する。

テンプレートファイルの場所はプラグインのインストールディレクトリ内の `templates/` を参照する。

### 3. CONVENTIONS.md のマージ

プラグインの `CONVENTIONS.md` の内容をプロジェクトの `CLAUDE.md` に追記する。

- `CLAUDE.md` が存在しない場合は新規作成
- 既に存在する場合は末尾に追記（重複チェック: 「GTD + Zettelkasten System」セクションが既にあればスキップ）

### 4. 個人設定ファイルのセットアップ

1. `.claude/` ディレクトリが存在しなければ作成
2. プラグインの `config.example.md` を `.claude/config.local.md` にコピー
3. ユーザーに以下を質問して設定を更新:
   - gcalcli のパス（デフォルト: `/usr/local/bin/gcalcli`）
   - カレンダーのメールアドレス
   - Slack 通知を有効にするか
   - GitHub の assignee 設定

### 5. .gitignore の更新

`.gitignore` に以下を追加（既にあればスキップ）:

```
.claude/config.local.md
.env
.DS_Store
```

### 6. scripts のコピー

プラグインの `scripts/` ディレクトリからプロジェクトの `scripts/` に以下をコピーする:

- `notify-slack.sh`
- `fetch-url.js`

### 7. 完了メッセージ

セットアップ完了後、以下を表示:

```
Vault のセットアップが完了しました!

作成されたディレクトリ:
  - gtd/inbox/, next-actions/, projects/, ...
  - zettelkasten/permanent/, literature/, fleeting/
  - templates/

設定ファイル:
  - .claude/config.local.md（個人設定 — 編集してください）
  - CLAUDE.md（規約が追記されました）

次のステップ:
  1. .claude/config.local.md を編集して個人設定を完了
  2. Slack を使う場合は .env に SLACK_WEBHOOK_URL を設定
  3. /gz:capture で最初のアイテムをキャプチャ!
```
