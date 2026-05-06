---
description: Generate an Architecture Decision Record (ADR) from a design decision or recent git diff.
---

# /adr

設計判断を ADR（Architecture Decision Record）として記録する。

## 動作

1. **入力の収集**
   - 引数があれば、それを設計判断の説明として使う: `/adr <説明>`
   - 引数がなければ、`git diff HEAD~1` から変更内容を読み取る

2. **ADR の構造を分析**
   - **Context**: なぜこの判断が必要だったか（背景・制約）
   - **Decision**: 何を決めたか（1 文で端的に）
   - **Alternatives Considered**: 検討した他の選択肢と却下理由
   - **Consequences**: この判断による影響（良い点・トレードオフ）

3. **ファイルに保存**
   - 保存先: `docs/adr/` または `decisions/`（存在するディレクトリを優先）
   - ファイル名: `ADR-{NNN}-{kebab-case-title}.md`（連番は既存ファイルから自動採番）

## 出力フォーマット

```markdown
# ADR-{NNN}: {タイトル}

**Status**: Proposed | Accepted | Deprecated | Superseded by ADR-{NNN}
**Date**: YYYY-MM-DD
**Deciders**: {関係者}

## Context

{なぜこの判断が必要だったか。技術的・ビジネス的な背景と制約。}

## Decision

{何を決めたか。能動態・現在形で1文。}
例: "We use PostgreSQL as the primary datastore."

## Alternatives Considered

| Option | Pros | Cons | Rejected because |
|---|---|---|---|
| {選択肢A} | ... | ... | ... |
| {選択肢B} | ... | ... | ... |

## Consequences

**Positive:**
- {良い点}

**Tradeoffs:**
- {トレードオフ・注意点}
```

## 使用例

```
/adr
```
→ 直近の git diff から自動生成

```
/adr TypeScript を Python の代わりに選んだ理由
```
→ 説明を元に生成

## 運用ルール

- **判断のたびに書く**（後から書くと記憶が薄れる）
- Status は `Proposed` で作成し、レビュー後に `Accepted` に更新
- 過去の ADR を変更しない。覆した場合は新しい ADR を作って `Superseded by` を記載

## 関連

- `docs/adr/` — ADR 保存先（なければ作成）
- `/debug` — バグの原因分析と修正判断を ADR として残す場合
