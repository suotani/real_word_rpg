# CLAUDE.md

このファイルはリポジトリ内のコードを扱う際に Claude Code (claude.ai/code) へのガイダンスを提供します。

## コマンド

```bash
# 初期セットアップ
./bin/setup

# 開発サーバー起動
bin/rails server

# データベース
bin/rails db:create db:migrate
bin/rails db:seed
bin/rails db:reset          # drop + create + migrate + seed
bin/rails db:migrate:status

# マイグレーション生成
bin/rails generate migration MigrationName

# テスト（Selenium/Chrome を使ったシステムテスト）
bin/rails test:system

# アセット（本番用）
bin/rails assets:precompile
```

## アーキテクチャ

**アプリ:** `RealRpg` — 現実世界のタスクをゲーム化するトラッカー。ユーザーはキャラクターを作成し、4つのステータス（うんどう・かしこさ・けんこう・にんき）で経験値を獲得、チケット（クエスト）をこなし、タウン/ストアのエコノミーに参加する。

**技術スタック:** Rails 7.2、Ruby 3.3.4、Devise認証、HAMLテンプレート、Bootstrap/Sass、jQuery、Sprockets、Active Storage + S3、Kaminariページネーション。開発/テストはSQLite、本番はPostgreSQL（Render）。

### モデル

- **`User`** — Devise認証；キャラクター・ストア・アイテム・管理HTML・タウンを所有
- **`Charactor`** — プレイヤーキャラクター。4つのステータス（level + exp のペア）: motion, knowledge, health, communication
- **`Experience`** — XP値とカテゴリを持つ再利用可能なタスク定義
- **`ExperienceLog`** — キャラクターが経験タスクを完了した記録
- **`Ticket`** — 1回限りのクエストアイテム；キャラクター1体につき最大5枚
- **`CharactorTicket`** — 中間テーブル：キャラクターに割り当てられたチケット
- **`Category`** — インメモリActiveHash（DBテーブルなし）；経験カテゴリを保持
- **`Town`** — パスワード付きのゲームタウン；ユーザーが所有
- **`UserTown`** — 多対多：ユーザーがタウンに参加するための中間テーブル
- **`Store`** — タウン内の店舗（テーマカラー・カテゴリ）
- **`Item`** / **`Stock`** — 店舗アイテムと在庫/価格
- **`ManagedHtml`** / **`ImportHtml`** / **`VR`** — ユーザー作成のHTML/JS/CSSページとVRコンテナ
- **`YamlToHtml`** — YAMLコンテンツをHTMLに変換

### コントローラー

- `DashboardController` — メインダッシュボード
- `CharactorsController`、`ExperiencesController`、`ExperienceLogsController` — キャラクタープログレッション
- `TicketsController`、`CharactorTicketsController` — クエスト管理
- `ShopsController` — ショップ閲覧
- `store/` 名前空間: `TownsController`、`StoresController`、`ItemsController`、`StocksController`、`DashboardController`
- `htmladmin/` 名前空間: カスタムHTMLコンテンツ管理
- `users/SessionsController` — Deviseセッションのカスタムオーバーライド

### サービス（`app/services/`）

レベルアップ通知のファクトリーパターン:
- `MessageService` — ファクトリーエントリーポイント
- `LevelMessageService` — レベルアップメッセージ生成
- `ExpMessageService` — XP獲得メッセージ生成

### 重要なパターン

- **トランザクション:** `ExperienceLogsController` はXP一括処理に `ActiveRecord::Base.transaction` を多用
- **Active Hash:** `Category` はインメモリハッシュ（DBテーブルなし）— マイグレーションを生成しないこと
- **HAML:** 全ビューは `.haml`（`.erb` ではない）
- **デプロイ:** `render.yaml` がRender.comの設定；`bin/render-build.sh` がデプロイ時に bundle/assets/migrate を実行
