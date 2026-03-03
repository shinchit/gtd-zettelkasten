---
description: URL/トピックから文献ノート作成
argument-hint: <URL or トピック>
allowed-tools: [Read, Write, Edit, Glob, Grep, Bash, WebFetch, WebSearch]
---

URL またはトピックを調査し、文献ノートを作成するコマンド。

ユーザー入力: $ARGUMENTS

## 手順

### 1. 入力の判別

`$ARGUMENTS` を解析:
- **URLの場合**: WebFetchで内容を取得 → Step 2a
- **トピック（テキスト）の場合**: WebSearchで調査 → Step 2b
- **入力なしの場合**: 「調べたいURLまたはトピックを教えてください」と質問

### 2a. URL調査

1. `WebFetch` でURLの内容を取得（失敗した場合やJSレンダリングが必要なサイトは `node scripts/fetch-url.js <URL>` で取得）
2. 以下を抽出:
   - タイトル
   - 著者（わかれば）
   - 主要なポイント（箇条書き3-5個）
   - 要約（3-5文）
3. 抽出結果をユーザーに表示し、追加の視点や気になる点を確認

### 2b. トピック調査

1. `WebSearch` でトピックを検索
2. 上位の検索結果から有用な情報を収集
3. 必要に応じて `WebFetch` で詳細を取得
4. 調査結果の要約をユーザーに表示し、深掘りしたい点を確認

### 3. 関連ノート検索

Vault内から関連するノートを検索:
- `zettelkasten/permanent/` — 関連する永続ノート
- `zettelkasten/literature/` — 同テーマの既存文献ノート
- `gtd/reference/` — 参考資料

関連ノートがあれば一覧表示する。

### 4. 文献ノート生成

ユーザーとの対話を踏まえ、以下のフォーマットで `zettelkasten/literature/YYYYMMDD-<slug>.md` を生成:

```markdown
---
type: literature
source: "<URL or 検索トピック>"
author: "<著者名>"
tags:
  - <適切なタグ>
created: YYYY-MM-DD
---

## Summary

<3-5文の要約>

## Key Points

- <ポイント1>
- <ポイント2>
- <ポイント3>

## Connections

- [[関連ノート]] — 関連の説明
```

### 5. 永続ノート化の提案

「この内容から永続ノート（自分の言葉でまとめたアイデア）を作成しますか？」
- **Yes** → `/zettel` と同様の対話フローで永続ノートを作成
- **No** → 文献ノートのみで完了

### 6. 完了表示

作成したノートの全文と保存先を表示する。

## 注意事項
- CLAUDE.md のフロントマター規約・命名規則に従うこと
- WebFetch/WebSearch が失敗した場合、ユーザーに内容を手動入力してもらう
- 著作権に配慮し、原文の大量コピーは避ける（要約・要点抽出に留める）
