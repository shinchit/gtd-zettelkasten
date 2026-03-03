---
description: Inbox にアイテムを素早くキャプチャ
argument-hint: <メモ or URL>
allowed-tools: [Read, Write, Glob, Bash, WebFetch]
---

Inboxにアイテムを素早くキャプチャするコマンド。

ユーザー入力: $ARGUMENTS

## 手順

1. `$ARGUMENTS` の内容を解析する
   - URLが含まれていれば `source: url` とし、WebFetchでタイトルと概要を取得する
   - WebFetchで内容を取得できない場合（JSレンダリングが必要なサイト等）は `node scripts/fetch-url.js <URL>` で取得する
   - それ以外は `source: manual` とする

2. ファイル名を生成する
   - フォーマット: `YYYYMMDD-HHmmss-<slug>.md`
   - `<slug>`: 内容を表す短い英語またはローマ字（ハイフン区切り、30文字以内）
   - 現在の日時を使用する

3. 以下のフロントマターでファイルを作成する

```yaml
---
type: inbox
captured: YYYY-MM-DDTHH:mm:ss
source: manual  # or url
---
```

4. フロントマターの後にキャプチャした内容を記述する
   - URLの場合: タイトル、URL、WebFetchで取得した概要
   - テキストの場合: ユーザーが入力した内容をそのまま記述

5. ファイルを `gtd/inbox/` に保存する

6. 完了メッセージを表示:
   「Inboxに追加しました: `<ファイル名>`」

## 注意事項
- CLAUDE.md のフロントマター規約に従うこと
- ファイル名にスペースを使わないこと
- 日本語のslugも可（例: `20240101-120000-kaigi-memo.md`）
