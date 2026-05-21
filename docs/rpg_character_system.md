# RPGキャラクタープログレッションシステム

ユーザーが現実世界の活動をゲーム内の経験値に変換し、キャラクターを成長させる中核サービス。

## 概要

キャラクターは4つのスキル（うんどう・かしこさ・けんこう・にんき）を持ち、現実の活動を「経験」として記録することでXPを獲得、レベルアップする。獲得したショップポイントで他キャラクターのチケットを購入できる。

## データモデル

### Charactor（キャラクター）

```
name                  string
user_id               integer
motion_level          integer  default: 1
knowledge_level       integer  default: 1
health_level          integer  default: 1
communication_level   integer  default: 1
motion_exp            integer  default: 0
knowledge_exp         integer  default: 0
health_exp            integer  default: 0
communication_exp     integer  default: 0
total_exp             integer  default: 0
shop_point            integer  default: 0
```

- `level()` メソッド: 合計レベル = (4スキルレベルの合計) - 3
- `set_level(category, exp_point)`: XP追加 + レベルアップ処理（100XP = 1レベル）
- `level_up?(category, exp_point)`: レベルアップするか確認

### Experience（経験タスク）

```
name         string   - 活動名（例: 本を読む）
unit         string   - 単位（ページ/回/個）
unit_exp     integer  - 1単位あたりのXP
explanation  string   - 活動の説明
charactor_id integer
category_id  integer  - ActiveHashのCategory ID (1-4)
```

### Ticket（チケット）

```
title        string
color        string   - 16進数カラーコード（UI表示用）
point        integer  default: 100  - 購入に必要なショップポイント
charactor_id integer  - 出品者キャラクター
```

制約: キャラクター1体につき最大5枚まで

### CharactorTicket（購入済みチケット）

```
ticket_id    integer
charactor_id integer
used         boolean  default: false
```

### Category（ActiveHash・DBテーブルなし）

| ID | 表示名     | column_name     |
|----|-----------|-----------------|
| 1  | うんどう   | motion          |
| 2  | かしこさ   | knowledge       |
| 3  | けんこう   | health          |
| 4  | にんき     | communication   |

## コントローラー

| コントローラー              | 主なアクション                                          |
|----------------------------|-------------------------------------------------------|
| `CharactorsController`     | index, show, create                                   |
| `ExperiencesController`    | index, new, create, edit, update, destroy             |
| `ExperienceLogsController` | create（XP付与・レベルアップ処理）                      |
| `TicketsController`        | index, create, edit, update, destroy                  |
| `CharactorTicketsController` | index, update（使用済みマーク）                      |
| `ShopsController`          | index（マーケット閲覧）, create（チケット購入）         |

## ルーティング

```ruby
resources :charactors, only: [:index, :show, :create] do
  resources :charactor_tickets
  resources :tickets
end
resources :experience_logs, only: [:create]
resources :experiences
resources :shops, only: [:index, :create]
```

## ユーザーフロー

### キャラクター作成

1. `/charactors` → キャラクター名を入力して作成
2. 全スキルがレベル1（合計レベル1）からスタート

### 経験タスクの設定とXP獲得

1. `/experiences/new` で経験タスクを作成（例: 本を読む / 1ページ = 10XP / カテゴリ: かしこさ）
2. キャラクター詳細画面（`/charactors/:id`）でタスク一覧を表示
3. タスクカードをクリックして単位数を選択（1〜4回分）
4. 送信すると `ExperienceLogsController#create` が処理:
   - カテゴリ別にXPを集計
   - 100XP以上でレベルアップ（余りは次レベルのXPへ）
   - 獲得XP = 獲得ショップポイント
5. レベルアップまたはXP獲得メッセージを返却（`MessageService` を使用）

### チケット売買

**出品側:**
1. `/charactors/:id/tickets/new` でチケット作成（最大5枚）
2. タイトル・カラー・ポイントを設定

**購入側:**
1. `/shops?charactor_id=:id` で他キャラクターのチケットを閲覧
2. ショップポイントが足りれば購入（トランザクション処理でポイント移転）
3. `/charactors/:id/charactor_tickets` で購入済みチケット一覧を確認
4. 使用時に `update` で `used: true` に変更

## サービスオブジェクト

```
app/services/
├── message_service.rb       # ファクトリー: レベルアップ or XP獲得メッセージを選択
├── level_message_service.rb # レベルアップメッセージ生成
└── exp_message_service.rb   # XP獲得メッセージ生成
```

`ExperienceLogsController#create` がレスポンスとして `MessageService` オブジェクトを返し、フロントエンドに結果を表示する。

## 注意事項

- `Category` はActiveHashのため、マイグレーション不要・DBテーブルなし
- `charactor` はスペルミス（correct: character）だが、既存のコードに合わせること
- `ExperienceLogsController#create` は複数カテゴリへのXP一括処理をトランザクションで行う重要な処理
