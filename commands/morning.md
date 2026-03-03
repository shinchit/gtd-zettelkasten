---
description: 日報生成 + モーニングページ + アクションプラン提案
allowed-tools: [Read, Write, Edit, Glob, Grep, Bash, WebFetch]
---

朝のルーティンを支援する日報生成コマンド。カレンダー・GitHub・タスクを統合し、1日の計画を立てる。

## 手順

### 0. 個人設定の読み込み

まず `.claude/config.local.md` を読み取り、個人設定を取得する。

- **Calendar セクション**: ツール名（gcalcli等）、ツールのフルパス、カレンダー名の一覧
- **Slack セクション**: 通知の有効/無効
- **GitHub セクション**: assignee 設定、対象リポジトリ一覧

`.claude/config.local.md` が存在しない場合:
- 「個人設定ファイルが見つかりません。`/gz:init` でセットアップするか、手動で情報を入力してください。」と表示
- ユーザーに手動入力を求める（カレンダーの予定、GitHub assignee 等）

### 1. コンディション確認

ユーザーに以下を質問する:
- 今日のエネルギーレベル（1-5）
- 今の気分を一言で

### 1.5. タスクヒアリング

ユーザーに「今日やりたいこと・気になっていることはありますか？」と質問する。

- ユーザーが項目を挙げた場合、それぞれについて:
  - 既にInboxやNext Actionsに存在するか確認
  - 存在しなければ `/capture` と同じ形式で `gtd/inbox/` に新規作成（`YYYYMMDD-HHmmss-<slug>.md`）
- 「なし」「特にない」等の場合はスキップ
- ここでキャプチャしたアイテムもステップ4.5のアクションプラン生成の対象に含める

### 2. カレンダー取得

`.claude/config.local.md` の Calendar セクションから設定を読み取り、カレンダー情報を取得する。

1. **設定からのカレンダー取得**:
   - `tool` で指定されたツール（デフォルト: gcalcli）を使用
   - `path` で指定されたフルパスでコマンドを実行
   - `calendars` で指定されたカレンダーを `--calendar` オプションで指定
   ```
   <path> agenda --nocolor --details=length <calendars...> $(date +%Y-%m-%d) $(date -v+1d +%Y-%m-%d)
   ```
   - 終日イベント（Length: 1 day）はスケジュールから除外し、時刻指定のイベントのみ表示する

2. **手動入力**: ツールが失敗した場合、または設定がない場合、「今日の予定を教えてください」と聞く

### 3. GitHub確認

`.claude/config.local.md` の GitHub セクションから assignee とリポジトリ一覧を読み取る。

- `assignee`: デフォルト `@me`
- `repos`: 対象リポジトリの一覧（`owner/repo` 形式）。未設定の場合はカレントディレクトリのリポジトリのみ

以下のコマンドでGitHub状況を取得:

```bash
# repos が設定されている場合、各リポジトリに対して実行
gh issue list --assignee <assignee> --state open --limit 10 --repo <owner/repo>
gh pr list --author <assignee> --state open --limit 10 --repo <owner/repo>

# repos が未設定の場合（カレントリポジトリ）
gh issue list --assignee <assignee> --state open --limit 10
gh pr list --author <assignee> --state open --limit 10
```

### 4. タスク確認

以下のファイルを読み取る:
- `gtd/next-actions/items/` 内の全ファイル → アクティブなNext Actionsを一覧
- 期限（`due`）が今日以前のものをハイライト
- `gtd/waiting-for/` 内のファイル → 待ち項目を一覧

### 4.5. アクションプラン生成

ステップ1〜4で収集したデータを分析し、今日おすすめのアクションを生成する。

#### 分析ルール

| 優先度 | データソース | 提案内容 |
|---|---|---|
| 1 | **期限切れ Next Actions** | `due` が今日以前のタスクを「最優先」として提案。具体的なタスク名とリンクを含める |
| 2 | **Inbox** (`gtd/inbox/`) | 未処理アイテムが1件以上あれば「`/inbox` で N 件処理」を提案 |
| 3 | **GitHub Issues/PRs** | レビュー待ちPRや担当Issueがあれば、対応アクションを提案 |
| 4 | **Waiting-for** | 作成日から7日以上経過したものにフォローアップを提案 |
| 5 | **Active Next Actions** | エネルギーレベルに応じてフィルタリングして提案: |
|   |                         | - energy 1-2: `energy: low` のタスク中心、`estimated-time: 5min〜15min` を優先 |
|   |                         | - energy 3: `energy: low〜medium` のタスク |
|   |                         | - energy 4-5: すべてのタスク（`energy: high` を含む） |

#### 空き時間の活用提案

カレンダーの予定間にある空き時間を特定し、時間帯ごとにおすすめタスクを割り当てる:
- **30分以上の空き**: 集中作業タスク（`estimated-time: 30min` 以上）を提案
- **15〜30分の空き**: 軽作業（Inbox処理、短いタスク）を提案
- **15分未満の空き**: 提案なし（休憩推奨）

#### 出力形式

提案は日本語で、簡潔に箇条書きで生成する。各提案にはタスクへのWikilinkを含める。

### 5. 日報生成

以下のフォーマットで `gtd/daily-logs/YYYY-MM-DD.md` を生成:

```markdown
---
type: daily-log
date: YYYY-MM-DD
energy: <ユーザー回答>
---

## Condition

- Energy: <回答>/5
- Mood: <回答>

## Today's Schedule

<!-- カレンダーから取得した予定を時系列で表示 -->

## GitHub Updates

### Open Issues
<!-- gh issue list の結果 -->

### Open PRs
<!-- gh pr list の結果 -->

## Priority Tasks

### Due Today / Overdue
<!-- 期限切れ・今日期限のNext Actions -->

### Active Next Actions
<!-- その他のアクティブなNext Actions（コンテキスト別） -->

### Waiting For
<!-- 待ち項目一覧 -->

## Recommended Actions

### 最優先（期限切れ・緊急）
<!-- 期限切れタスク、緊急対応が必要なもの -->

### 今日取り組むべきタスク
<!-- エネルギーレベルとスケジュールの空き時間を考慮して選定 -->
<!-- 空き時間帯ごとのおすすめも含む -->

### 低エネルギーでもできること
<!-- Inbox処理、軽い確認作業、フォローアップなど -->

## Notes

```

### 6. 日報の確認

生成した日報を表示し、修正があるか確認する。

### 7. モーニングページへの誘導

日報確認後、以下を提案:
「モーニングページを書きますか？思い浮かぶことを自由に書き出す時間です。」

- **Yes** の場合: `gtd/daily-logs/YYYY-MM-DD-morning-page.md` を以下のフロントマターで作成:
  ```yaml
  ---
  type: morning-page
  date: YYYY-MM-DD
  ---
  ```
  ユーザーの入力をそのまま記録する。「終わり」「done」「以上」などの終了ワードで完了。

- **No** の場合: ステップ8へスキップ

### 7.5. モーニングページからの仕事メモ抽出

モーニングページを書いた場合のみ実行する。

モーニングページの内容を分析し、**仕事に関連する気づき・メモだけ**を抽出して日報の `## Notes` セクションに追記する。

#### 抽出ルール

- **含める**: 仕事のアイデア、業務改善の気づき、チームへの共有事項、技術的なメモ
- **除外する**: プライベートな感情・悩み、個人的な予定、健康・家族の話題、ネガティブな愚痴
- 抽出結果は簡潔な箇条書きにまとめる（原文をそのまま転記しない）
- 抽出すべき仕事メモがない場合は `## Notes` を空のままにする

#### 処理フロー

1. モーニングページの内容を読み取る
2. 仕事向けの気づきを抽出・要約
3. 抽出結果をユーザーに提示し、日報に追記してよいか確認する
4. 承認されたら `## Notes` セクションに追記

### 8. Slack通知

`.claude/config.local.md` の Slack セクションを確認する。

- **enabled: false** の場合: スキップ
- **enabled: true** の場合: 以下を提案:
  「この日報をSlackに通知しますか？」
  - **Yes** の場合: `bash scripts/notify-slack.sh gtd/daily-logs/YYYY-MM-DD.md` を実行
    - 成功: 「Slackに通知しました」
    - 失敗: 「Slack通知に失敗しました（Webhook URLを確認してください）」
  - **No** の場合: スキップ

※ モーニングページ本体は通知対象外（日報のNotesに抽出された内容のみ通知される）

「良い一日を!」で終了

## 注意事項
- 日報ファイルが既に存在する場合は上書き確認する
- CLAUDE.md のフロントマター規約に従うこと
- カレンダー取得に失敗してもエラーにせず、スキップして次に進む
