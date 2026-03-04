---
description: 日報データの傾向分析（エネルギー推移・タスク完了率・曜日パターン等）
argument-hint: [日数 (デフォルト: 30)]
allowed-tools: [Read, Write, Edit, Glob, Grep, Bash]
---

直近の日報データから傾向を分析し、インサイトを表示する。

引数（オプション）: 分析対象日数（デフォルト: 30）

ユーザー入力: $ARGUMENTS

## 手順

### 1. データ収集

1. `git pull` で最新状態に更新する
2. `gtd/daily-logs/` から直近 {対象日数} 日分の日報ファイル（`YYYY-MM-DD.md`）を読み込む
   - `weekly-review`、`morning-page`、`insights` ファイルは除外
   - ファイルが 3 日分未満の場合は「分析に十分なデータがありません」と表示して終了

### 2. 集計指標

以下の指標をすべて集計する。

**エネルギー推移**
- フロントマターの `energy` 値（1-5）の日別推移
- 平均値、最高/最低の日、直近の傾向（上昇/下降/安定）
- Mood の頻出ワードも収集

**タスク完了率**
- 各日の `## Recommended Actions` セクションから: 全タスク数、リンク記法 `[[...]]` で記述されたアクション数
- 日報の Notes セクションに完了の記録がある場合も考慮
- `gtd/next-actions/done/` に移動済みのタスクは完了とみなす
- 日別の完了状況と期間全体の傾向

**繰り越し分析**
- 同じタスク名（Wikilink先）が複数日の Recommended Actions に出現 → 繰り越し
- 繰り越し回数が多いタスクをランキング表示

**空き時間活用の傾向**
- `## Today's Schedule` から空き時間の総量を推定
- `## Recommended Actions` の 🟡 / 🟢 セクションでの提案数と実行状況

**曜日別パターン**
- 曜日ごとの平均エネルギー、平均タスク数
- エネルギーが高い/低い曜日

**GitHub 活動**
- Open Issues / PRs の推移
- 新規作成・クローズの傾向（データがある場合）

### 3. 分析結果の表示

以下のフォーマットで表示する:

```markdown
## Insights — {期間}日間（{開始日} 〜 {終了日}）

### Overview

| 指標 | 値 |
|---|---|
| 分析対象日数 | X 日（うち日報あり Y 日） |
| 平均エネルギー | X.X / 5 |
| 最高エネルギーの日 | YYYY-MM-DD (X/5) |
| 最低エネルギーの日 | YYYY-MM-DD (X/5) |

### Energy Trend

（日別のエネルギーを簡易チャートで表示）

```
03/01 ████░ 4
03/02 ███░░ 3
03/03 ██░░░ 2
03/04 ██░░░ 2
```

傾向: {上昇/下降/安定} — {コメント}

### Mood Keywords

（Mood の頻出ワードを表示）

### Carry-Over Ranking

（2回以上繰り越されたタスクを表示）

| タスク | 繰り越し回数 | 提案 |
|---|---|---|
| ... | X回 | 分割する / Someday に移す / 2分で片付く部分だけやる |

### Weekday Patterns

| 曜日 | 日報数 | 平均エネルギー | 平均タスク数 |
|---|---|---|---|
| Mon | X | X.X | X.X |
| ... | | | |

### Energy Level Analysis

（エネルギーレベル別の傾向）

| Energy | 日数 | 傾向 |
|---|---|---|
| 4-5 (高) | X日 | Mood: {頻出ワード} |
| 3 (中) | X日 | Mood: {頻出ワード} |
| 1-2 (低) | X日 | Mood: {頻出ワード} |

低エネルギー日の前日パターン:
- 前日の予定数平均: X.X（通常: Y.Y）
- 前日のエネルギー平均: X.X（通常: Y.Y）

### Observations

（データから読み取れる気づきを3〜5点。例:）
- 月曜のエネルギーが高い → 週末でしっかり休めている
- エネルギー2以下の日は予定が多い前日の翌日に集中
- 繰り越し常連タスクは分割 or Someday 行きを検討
- Mood に「眠い」が多い → 睡眠の質を見直す余地あり
```

### 4. アクション提案

「このインサイトを踏まえて、何かアクションしたいことはありますか？」と質問する。
- アクションがあれば `gtd/inbox/` に追加 or `gtd/next-actions/items/` に直接追加

### 5. レポート保存

分析結果を `gtd/daily-logs/YYYY-MM-DD-insights.md` として保存する。

```yaml
---
type: insights
date: YYYY-MM-DD
period: {対象日数}
period_start: YYYY-MM-DD
period_end: YYYY-MM-DD
---
```

### 6. コミット & プッシュ

```
git add gtd/daily-logs/YYYY-MM-DD-insights.md
git commit -m "Add insights report ({対象日数} days: {開始日}〜{終了日})"
git push
```

## 注意事項
- データが少ない場合（3日未満）は無理に分析せず、データ蓄積を促す
- 数値だけでなく、パターンや気づきを言語化して提示する
- プライバシーに配慮し、Mood の内容は統計的に扱う（個別の感情を深掘りしない）
- Morning Page の内容は分析対象に含めない（日報のみ）

## Credits

This command was inspired by [kinjo-shuya](https://dev.classmethod.jp/author/kinjo-shuya/)'s `/insights` skill implementation.
