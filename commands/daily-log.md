---
description: 1日の振り返り（タスク完了確認・Three Good Things・Next Actions 整理）
allowed-tools: [Read, Write, Edit, Glob, Grep, Bash]
---

1日の振り返りと日報の完成を行うコマンド。朝の `/gz:morning` で作成した日報をもとに、タスクの完了状況を確認し、振り返りを記録する。

## 手順

### 1. 最新状態に更新

`git pull` で最新状態に更新する。

### 2. 日報の読み込み

`gtd/daily-logs/YYYY-MM-DD.md`（今日の日付）を読み込む。

- 存在しない場合: 「今日の日報が見つかりません。`/gz:morning` で作成してください。」と表示して終了

### 3. タスク完了状況の確認

日報の `## Recommended Actions` セクションに記載されたタスク（`[[...]]` リンク）を1つずつ確認する:

各タスクについて対話:
```
{タスク名}
完了しましたか？
1. 完了
2. 明日に繰り越し
3. もう不要（削除）
4. Someday に移動
```

#### 完了したタスクの処理

1. `gtd/next-actions/items/` から同名タスク（ファイル名の slug 部分一致で判定）を探す
2. 見つかった場合:
   - `git mv` で `gtd/next-actions/done/` に移動
   - フロントマターに `completed: YYYY-MM-DD` を追加
3. プロジェクトファイル（`gtd/projects/items/`）に同じタスクが Next Actions リストにあれば `[x]` に変更
4. 日報の `## Done` セクションに追記（一言メモ付き）

#### 繰り越しタスクの処理

- 日報に残す（翌日の `/gz:morning` で Recommended Actions に再度拾われる）
- Next Actions のファイルはそのまま `items/` に残留

#### 不要タスクの処理

- `gtd/next-actions/items/` から該当ファイルを削除（ユーザー確認後）

#### Someday に移動

- `gtd/someday-maybe/` に移動し、`type: someday-maybe` に変更

### 4. 振り返りの質問

以下を対話で収集する:

1. **Three Good Things**: 「今日よかったこと3つを教えてください」
   - 大きなことでなくてOK。小さな良いことでも。
2. **Notes**: 「気づきやメモはありますか？」（なければスキップ）
3. **Tomorrow**: 「明日やりたいことは？」（翌日の `/gz:morning` に引き継ぎ）
4. **Rating**: 「今日の1日を振り返って、評価は？（1〜5）」

### 5. 日報の更新

既存の日報に以下のセクションを追記・更新する:

- フロントマターに `rating: {1〜5}` を追加
- `## Done` セクションを追加（完了タスク + 一言メモ）
- `## Three Good Things` セクションを追加
- `## Notes` セクションに追記（既存の内容は保持）
- `## Tomorrow` セクションを追加

更新後の日報フォーマット:

```markdown
---
type: daily-log
date: YYYY-MM-DD
energy: {朝の値}
rating: {振り返りの値}
---

## Condition

（朝の記録 — 変更なし）

## Today's Schedule

（朝の記録 — 変更なし）

## GitHub Updates

（朝の記録 — 変更なし）

## Priority Tasks

（朝の記録 — 変更なし）

## Recommended Actions

（朝の記録 — 変更なし）

## Done

- {完了タスク1} — {一言メモ}
- {完了タスク2} — {一言メモ}

## Three Good Things

1. {よかったこと1}
2. {よかったこと2}
3. {よかったこと3}

## Notes

{朝の Notes + 振り返りの Notes}

## Tomorrow

- {明日やりたいこと}
```

### 6. 日報の確認

更新した日報を表示し、修正があるか確認する。

### 7. 完了メッセージ

```
お疲れさまでした!

完了: X 件 → gtd/next-actions/done/
繰り越し: X 件
削除/Someday: X 件
Rating: X/5

良い夜を!
```

## 注意事項
- 朝の日報の内容（Condition, Schedule 等）は変更しない — 追記のみ
- Next Actions の移動は `git mv` を使い、Git 履歴を保持する
- プロジェクトの全 Next Actions が完了した場合、プロジェクト完了を提案する
- Morning Page の内容には触れない（プライバシー保護）

## Credits

This command was inspired by [kinjo-shuya](https://dev.classmethod.jp/author/kinjo-shuya/)'s `/daily-log` skill implementation, which separates morning planning from end-of-day reflection.
