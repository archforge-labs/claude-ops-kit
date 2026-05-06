# claude-ops-kit

Claude Code を使った集中的なプロジェクト運用を支える、最小限のツールキット。

フック・コマンド・エージェントで構成され、10 週間の転職活動スプリントで実運用しながら作り込んだ。

## 何が入っているか

| 種別 | ファイル | 用途 |
|---|---|---|
| Hook | `hooks/session-start.sh` | セッション開始時に週番号・経過日数・締め切りまでの残日数を表示 |
| Hook | `hooks/stop.sh` | セッション終了時に今週のログファイルへ自動追記 |
| Command | `commands/weekly-review.md` | 週次レビューを実行してログを更新する |
| Agent | `agents/job-application-reviewer.md` | 応募書類（志望動機・職務経歴書）の提出前レビュー |

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
    ]
  }
}
```

## 使い方

### セッション追跡

フック登録後は Claude Code が自動で:
- セッション開始時にプロジェクト状況を表示
- セッション終了時に `logs/weekly/W{N}.md` へ終了時刻と最新コミットを追記

### 週次レビュー

```
/weekly-review
```

現在の週番号を判定し、`logs/weekly/W{N}.md` を開いて進捗・振り返りを記録する。

### 応募書類レビュー

`agents/job-application-reviewer.md` の `[YOUR_*]` プレースホルダーを自分のプロフィールに書き換えて使う。

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

- 2026-05-06 23:30 | `a1b2c3d feat: 機能追加` / uncommitted: 2 files
```

## 設計方針

- **依存ゼロ** — 純粋な bash と Markdown のみ
- **設定ファイル中心** — パスや日付はすべて `.ops-kit-config` に集約
- **非破壊的** — ログファイルが存在しなければフックは何もしない
- **macOS / Linux 対応** — `date` と `gdate` の両方に対応

## ライセンス

MIT
