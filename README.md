# claude-ops-kit

Claude Code を使ったソフトウェア開発ワークフローを支える、実用的なツールキット。

フック・コマンド・エージェントで構成され、実プロジェクトで実運用しながら作り込んだ。

## 何が入っているか

| 種別 | ファイル | 用途 |
|---|---|---|
| Hook | `hooks/session-start.sh` | セッション開始時に週番号・経過日数・締め切りまでの残日数を表示 |
| Hook | `hooks/stop.sh` | セッション終了時に今週のログファイルへ自動追記 |
| Hook | `hooks/pre-edit-guard.sh` | `.env` / `schema.sql` など機密ファイル編集前に警告 |
| Command | `commands/weekly-review.md` | 週次レビューを実行してログを更新する |
| Command | `commands/standup.md` | git ログから日次スタンドアップを生成 |
| Command | `commands/adr.md` | 設計判断を ADR（Architecture Decision Record）として記録 |
| Command | `commands/debug.md` | 症状→仮説→検証の構造化デバッグフロー |
| Agent | `agents/code-reviewer.md` | CRITICAL / HIGH / MEDIUM / LOW でコードをレビュー |

## インストール

```bash
git clone https://github.com/archforge-labs/claude-ops-kit
cd claude-ops-kit
./install.sh /path/to/your-project
```

カレントディレクトリにインストールする場合:

```bash
./install.sh
```

## 設定

プロジェクトルートの `.ops-kit-config` を編集する:

```bash
OPS_KIT_START_DATE="2026-01-01"   # プロジェクト開始日（必須）
OPS_KIT_TARGET_DATE="2026-07-01"  # 締め切り日（任意）
OPS_KIT_LOG_DIR="logs/weekly"     # 週次ログの置き場所
OPS_KIT_PROJECT_NAME="My Project" # 表示名
```

## フック登録

プロジェクトの `.claude/settings.json` に追加する:

```json
{
  "hooks": {
    "SessionStart": [
      { "type": "shell", "command": ".claude/hooks/session-start.sh" }
    ],
    "Stop": [
      { "type": "shell", "command": ".claude/hooks/stop.sh" }
    ],
    "PreToolUse": [
      { "type": "shell", "command": ".claude/hooks/pre-edit-guard.sh" }
    ]
  }
}
```

## 使い方

### セッション追跡

フック登録後は Claude Code が自動で:
- セッション開始時にプロジェクト状況を表示
- セッション終了時に `logs/weekly/W{N}.md` へ終了時刻と最新コミットを追記
- 機密ファイル編集前に警告を出力

### 開発コマンド

```
/standup        # 今日の作業報告を git ログから生成
/adr            # 直近の変更から設計判断を ADR として記録
/adr <説明>     # 説明文から ADR を生成
/debug          # 構造化デバッグフローを開始
/debug <エラー> # エラーメッセージから仮説を生成
/weekly-review  # 週次振り返りとログ更新
```

### コードレビュー

`code-reviewer` エージェントを呼ぶと、CRITICAL / HIGH / MEDIUM / LOW の 4 段階でレビューを実施する。

## 週次ログの構造

ログは `OPS_KIT_START_DATE` からの週番号で自動的に振り分けられる。

```
logs/
└── weekly/
    ├── W0.md
    ├── W1.md
    └── W2.md
```

stop フックによって各ファイルに以下が自動追記される:

```
## セッションログ

- 2026-05-07 23:30 | `a1b2c3d feat: 機能追加` / uncommitted: 2 files
```

## 設計方針

- **依存ゼロ** — 純粋な bash と Markdown のみ（`pre-edit-guard.sh` は python3 を使用）
- **設定ファイル中心** — パスや日付はすべて `.ops-kit-config` に集約
- **非破壊的** — ログファイルが存在しなければフックは何もしない
- **macOS / Linux 対応** — `date` と `gdate` の両方に対応

## ライセンス

MIT
