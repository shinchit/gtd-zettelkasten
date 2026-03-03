---
description: GTD 週次レビュー（システム全体の健全性チェック）
allowed-tools: [Read, Write, Edit, Glob, Grep, Bash]
---

GTDの週次レビューを実施するコマンド。Inbox、プロジェクト、Next Actions、Zettelkastenの健全性を包括的にチェックする。

## 手順

### 1. Inbox残数チェック

`gtd/inbox/` 内の `.md` ファイル数をカウント。
- 0件: 「Inboxは空です」
- 1件以上: 「Inboxに未処理アイテムが N 件あります。レビュー後に `/inbox` で処理してください。」

### 2. プロジェクト進捗確認

`gtd/projects/items/` 内の全プロジェクトを読み取り:
- 各プロジェクトの `status`、`outcome`、関連するNext Actionsを表示
- 関連するNext Actionsがないプロジェクトを警告（「Next Actionなし」）
- `created` から2週間以上経過してNext Actionsが進んでいないプロジェクトを警告（「停滞中」）
- プロジェクトごとに「継続 / 保留 / 完了 / 削除」を確認

### 3. Next Actions チェック

`gtd/next-actions/items/` 内の全ファイルを読み取り:
- 期限切れ（`due` < 今日）のアクションを警告
- プロジェクトに紐づかない孤立アクションを表示
- コンテキスト別にグルーピングして表示
- 各アクションの確認:「まだ有効？ / 完了 / 削除 / 変更」

### 4. Waiting-for フォローアップ

`gtd/waiting-for/` 内の全ファイルを読み取り:
- 各項目の内容と経過日数を表示
- フォローアップが必要かどうかを確認

### 5. Someday-Maybe 昇格判断

`gtd/someday-maybe/` 内の全ファイルを読み取り:
- 各項目を表示し「今やる（Next Action化） / そのまま / 削除」を確認
- 昇格する場合は `/inbox` と同様のメタデータ収集

### 6. Zettelkasten 健全性チェック

`zettelkasten/permanent/` と `zettelkasten/literature/` を分析:
- **孤立ノート**: `## Connections` セクションにリンクがないノート
- **片方向リンク**: `[[リンク先]]` があるが、リンク先から戻りリンクがないペア
- **タグ分布**: 使用されているタグの頻度分布
- 統計情報: 永続ノート数、文献ノート数、一時メモ数

### 7. 全体統計

以下の統計を表示:
- Inbox: N 件
- Next Actions: N 件（期限切れ: N 件）
- Projects: N 件（停滞: N 件）
- Waiting-for: N 件
- Someday-Maybe: N 件
- Zettelkasten: 永続 N 件 / 文献 N 件 / 一時 N 件
- 孤立ノート: N 件
- 片方向リンク: N 件

### 8. 週次レビューレポート生成

対話の結果を `gtd/daily-logs/YYYY-MM-DD-weekly-review.md` に保存:

```markdown
---
type: weekly-review
date: YYYY-MM-DD
---

## Summary

<!-- 全体統計 -->

## Inbox

- 未処理: N 件

## Projects

<!-- プロジェクト別の状態 -->

## Next Actions

<!-- コンテキスト別の一覧、期限切れハイライト -->

## Waiting For

<!-- 待ち項目と経過日数 -->

## Someday / Maybe

<!-- 判断結果 -->

## Zettelkasten Health

<!-- 孤立ノート、片方向リンク、統計 -->

## Actions Taken

<!-- このレビューで行った変更の記録 -->
```

### 9. 完了

「週次レビューが完了しました。レポート: `gtd/daily-logs/YYYY-MM-DD-weekly-review.md`」

## 注意事項
- CLAUDE.md のフロントマター規約に従うこと
- ファイル移動や削除はユーザーの確認を得てから実行すること
- 大量のアイテムがある場合、サマリーから始めて詳細は必要に応じて表示
- レビュー中の変更（完了マーク、移動等）は即座に反映する
