# タウン・ストアエコノミーシステム

ユーザーが仮想の街を作成・参加し、店舗を構えて在庫を管理するサービス。`store/` 名前空間で完結している。

## 概要

「タウン」を単位としたコミュニティに複数ユーザーが参加し、各自が「ストア（店舗）」を持ち在庫を管理する。在庫（Stock）はアイテム名と素材カテゴリ（ItemSubCategory）を直接持ち、製造コストと販売価格を管理する。ストアはレシピ（Recipe）を持ち、レシピが必要とする素材カテゴリに一致する在庫を消費して新たな在庫を生成できる。

## 経済フロー

```
[タウン作成]
  → 中央卸売市場（user_id: nil, town_id: nil）が自動生成
  → WholesaleItemsImporter が全 ItemSubCategory（グローバル）の初期在庫を price: 100円 で登録

[銀行借り入れ] BanksController#borrow
  → 最大 MAX_LOAN 円まで借り入れ可能。balance と loan_amount を同時に増減
  → 返済は BanksController#repay（残高が足りなければ失敗）

[仕入れ] StoreActions#buy
  → 市場の Stock を選択 → 自分の Store（store_category が一致する）を選択 → 数量を入力
  → User.balance から price × quantity を deduct!
  → 自 Store に Stock を create!（cost = 市場の price）

[まとめて仕入れ] Stocks#bulk_new / bulk_confirm / bulk_create
  → 自店舗の在庫を複数まとめて追加する一括登録フロー

[出品] Stocks#list
  → 販売価格を入力（1円以上）→ listed: true にする
  → 「取り消し」は Stocks#unlist で listed: false に戻す

[ユーザー間購入] StoreActions#purchase
  → 他ユーザーの出品中 Stock を選択 → 受け取り先 Store を選択
  → 購入者の balance から price を deduct!
  → 出品者の balance に price を increment! かつ SalesLog に記録
  → 出品 Stock を destroy し、受け取り先 Store に新 Stock を create!

[仮想顧客バッチ] VirtualCustomerBatchService
  → 毎時0分、POST /api/batches/virtual_purchase（X-Batch-Token 認証）でキューに投入
  → BuisinessTime.sales_at が現在時刻の hour に一致する StoreCategory の店舗のみ対象
  → タウンごとに独立した仮想購入者 20人（所持金 500〜3000円 ランダム）が購入を試みる
  → 購入優先順位は「魅力度」（高い順）。魅力度 < 0.5 の商品は購入対象外
  → 売れたら出品者の balance を increment! + SalesLog に記録 → Stock を destroy
  → 売れ残った在庫は unsold_count をインクリメント（魅力度には影響しない）

[市場価格変動バッチ] MarketPriceFluctuationService
  → 毎日1時30分、POST /api/batches/market_price_fluctuation（X-Batch-Token 認証）で起動
  → 中央卸売市場の全 Stock の price を ±5円 ランダムに変動（最低 1円）
```

店舗カテゴリによる絞り込み：仕入れ・購入時、`item_sub_category → item_category → store_category` を遡って、同じ `store_category` を持つ自店舗のみ選択肢に表示する。

## 魅力度（attractiveness）

仮想顧客が購入対象を選ぶ際の指標。高いほど先に購入される。

```
魅力度 = (cost ÷ price) + ingredient_count × 0.1
```

- `cost / price` が高い（＝安売り）ほど魅力度が上がる
- レシピで素材を多く使って作った商品ほどボーナスが付く
- `unsold_count`（売れ残り回数）は記録されるが魅力度には影響しない
- 閾値 `MIN_ATTRACTIVENESS = 0.5` を下回ると購入対象から外れる

## ユーザーフロー

### ガイド

`/store/guide` にステップ形式の初心者ガイドあり。以下の順序を推奨:

1. まちをつくる
2. 銀行から借り入れ
3. お店をひらく
4. 市場で仕入れ
5. 商品を出品
6. 仮想顧客が毎時購入
7. レシピでクラフト
8. 銀行に返済

### 街の作成

1. `/store/towns/new` で街の名前を入力
2. 8文字の英数字パスワードが自動生成される
3. `Town`・`UserTown`（作成者分）が作成され、中央卸売市場が自動生成される
4. ダッシュボードにリダイレクト（パスワードが表示される）

### 街への参加

1. `/store/towns/join_request` で街の名前とパスワードを入力
2. 一致する `Town` が存在し、未参加であれば `UserTown` が作成される
3. `user.town` を新タウンに切り替え、参加後は市場・他店舗にアクセス可能

### 銀行

- `/store/bank` で借り入れ・返済が可能
- 最大借入額は `User::MAX_LOAN`
- `borrow!`（残枠チェック）/ `repay!`（残高・借入残高チェック）が `User` モデルに定義済み

### 店舗の作成

1. `current_user.town` が設定済みであること（`stores#new` でチェック、なければ select へリダイレクト）
2. `/store/stores/new` で店舗名・カテゴリ（`卸市場` 以外）・テーマカラー2色を設定
3. `current_user.town` に紐づいて作成される

### 在庫の仕入れ（市場から）

1. `/store/towns/:id/market` で中央卸売市場の在庫一覧を表示（`ItemCategory` フィルタ対応）
2. 仕入れたい Stock を選択し `buy` アクションへ
3. 受け取り先の自店舗を選択 → 数量を指定 → 購入（1〜99個）
4. `bulk_new` / `bulk_confirm` / `bulk_create` でまとめて仕入れることも可能

### 在庫の出品と購入

1. 自店舗の在庫一覧（`stocks#index`）から「出品する」→ 価格設定（`stocks#list`）
2. 他ユーザーが `/store/stores/:id` で出品中在庫を確認し `purchase` で購入
3. 「取り消し」で `listed: false` に戻せる（`stocks#unlist`）

### ショッピングストリート

- `/store/shopping_street` で同タウン内の全店舗一覧と出品商品を閲覧できる

### レシピによる在庫生成（クラフト）

1. `/store/stores/:store_id/recipes/new` でレシピを作成
   - レシピ名・生成する在庫の出力 `ItemSubCategory`（複数）を指定
2. `recipes#craft` でレシピを実行
   - `item_sub_category_id` が一致する Stock を各1個消費
   - 素材の cost 合計を cost とした新 Stock を生成（price: 0 で未出品状態）

> edit / update は first リリース対象外。変更したい場合は削除して再登録で対応。

### 売上記録

- `/store/sales_logs` で日ごとの売上件数・売上金額・コスト・利益を確認できる
- 年・月を指定して月単位で表示（デフォルト: 今月）
- テーブル下部に月間合計行あり

## 注意事項

- ユーザーは複数の街に参加できる（`user_towns`）が、`current_user.town` が現在アクティブな街を示す（`TownsController#switch` で切り替え）
- `theme_color` と `theme_sub_color` は異なる値でなければならない（バリデーションあり）
- `BuisinessTime` はスペルミス（correct: BusinessTime）だが、既存のコードに合わせること
- 中央卸売市場（`user_id: nil, town_id: nil`）はシステム所有の Store。`Store.central_wholesale_market` クラスメソッドで取得する
- `Item` / `Material` テーブルは新設計では不要。`Stock` が名前と素材カテゴリを直接持つ

## データモデル

### Town（街）

```
name      string   - 街の名前（ユニーク、最小2文字）
user_id   integer  - 作成者
password  string   - 参加パスワード（8文字英数字、自動生成）
```

- 作成者は `UserTown` レコードも同時に作成される
- `after_create` で中央卸売市場と初期在庫を自動生成（`skip_wholesale_market_setup` フラグで抑制可能）

### UserTown（ユーザー↔街の中間テーブル）

```
user_id   integer
town_id   integer
```

### User（残高・借入）

```
balance      integer  default: 0  - 現在の残高
loan_amount  integer  default: 0  - 現在の借入残高
```

主なメソッド:
- `afford?(amount)` — 残高チェック
- `deduct!(amount)` — 残高を減らす
- `borrow!(amount)` — 借り入れ（`MAX_LOAN` 上限チェックあり）
- `repay!(amount)` — 返済（残高・借入残高チェックあり）

### Store（店舗）

```
name              string  - 店舗名（街内でユニーク）
town_id           integer  optional  - NULLの場合はシステム店舗（中央卸売市場）
user_id           integer  optional  - NULLの場合はシステム所有
store_category_id integer
theme_color       string  - メインカラー (#RRGGBB)
theme_sub_color   string  - サブカラー (#RRGGBB、メインと異なる値が必要)
```

- `has_many :stocks`
- `has_many :recipes`
- `Store.central_wholesale_market` — `user_id: nil` かつ `store_category.name: '卸市場'` の Store を返す

### Stock（在庫）

```
name                 string   - 在庫アイテム名
store_id             integer  optional  - NULLの場合は倉庫在庫
user_id              integer  optional  - NULLの場合はシステム在庫（中央卸売市場）
item_sub_category_id integer  optional  - 素材カテゴリの分類
cost                 integer  - 仕入れ・製造コスト
price                integer  - 販売価格（出品時は 1円以上必須）
listed               boolean  - 出品中フラグ（true のとき他ユーザーが購入可能）
attractiveness       float    - 魅力度（バッチ実行時に再計算）
ingredient_count     integer  - レシピで使用した素材数（魅力度ボーナス算出用）
unsold_count         integer  - 売れ残り回数（記録のみ、魅力度には影響しない）
sort_key             string   - 管理画面での並べ替えキー（卸市場の在庫管理用）
```

定数:
- `INGREDIENT_WEIGHT = 0.1` — 素材1個あたりの魅力度ボーナス

### SalesLog（売上記録）

```
user_id       integer
target_date   date     - 記録対象日（1日1レコード）
sales_count   integer  - 販売件数
sales_amount  integer  - 売上金額合計
cost_amount   integer  - コスト合計
```

- `SalesLog.record_sale!(user, price, cost)` — 当日分のレコードに累積加算（仮想顧客バッチ・ユーザー間購入の両方で呼ばれる）
- `profit_amount` — `sales_amount - cost_amount`

### BatchLog（バッチ実行ログ）

```
target_date   date
hour          integer  - 実行時刻のhour（-1 = 日次サマリー）
```

- `SUMMARY_HOUR = -1` — 日次サマリーを示す特殊値
- `scope :hourly` / `scope :summary` / `scope :for_date`

### ItemCategory / ItemSubCategory / StoreCategory（カテゴリ）

```
StoreCategory:    name                                            例）飲食店
ItemCategory:     name, store_category_id（多対多）              例）野菜、肉類、飲料
ItemSubCategory:  name, item_category_id, town_id optional      例）かぼちゃ、りんご
```

`StoreCategory → ItemCategory → ItemSubCategory` という3段階の階層構造。`ItemSubCategory` が最小単位。

- `town_id: nil` のものがグローバルマスタ（中央卸売市場の初期在庫に使用）
- `StoreCategory` と `ItemCategory` は多対多（`ItemCategoryStoreCategory` 中間テーブル）
- `Stock` は `item_sub_category_id` を持ち、レシピ照合・仕入れ先絞り込みに使用

### Recipe（レシピ）

```
store_id  integer  - レシピを持つ店舗
name      string   - レシピ名
```

- `has_many :item_sub_categories, through: :recipe_item_sub_categories`

### RecipeItemSubCategory（レシピ↔サブカテゴリの中間テーブル）

```
recipe_id            integer
item_sub_category_id integer
```

### BuisinessTime（営業時間）

```
store_category_id  integer  - FK
sales_at           integer  - 営業している時刻（hour、0〜23）
```

仮想顧客バッチが `BuisinessTime.where(sales_at: hour)` で営業中の StoreCategory を絞り込む。

## コントローラー

| コントローラー | 主なアクション |
|---|---|
| `store/DashboardController` | index |
| `store/GuideController` | index |
| `store/TownsController` | index, new, create, select, switch, join_request, join, market |
| `store/StoresController` | index, show, new, create, edit, update |
| `store/StocksController` | index, show, create, edit, update, destroy, list(GET/POST), unlist(POST), bulk_new, bulk_confirm, bulk_create |
| `store/RecipesController` | index, new, create, destroy, craft |
| `store/StoreActionsController` | buy(GET/POST), purchase(GET/POST), sell(POST・未実装) |
| `store/OtherStoresController` | index（同タウンの他ユーザー店舗一覧） |
| `store/ShoppingStreetController` | index（同タウン全店舗・出品商品一覧） |
| `store/BanksController` | show, borrow(POST), repay(POST) |
| `store/SalesLogsController` | index（年・月パラメータで月別絞り込み） |
| `store/VirtualCustomerBatchesController` | show, create（管理者専用・手動実行UI） |
| `store/BuisinessTimesController` | index |
| `store/ItemSubCategoriesController` | index, new, create, import_master(POST) |
| `store/ItemCategoriesController` | index, new, create, edit, update, destroy |
| `store/StoreCategoriesController` | index, new, create, edit, update, destroy, assign_item_category(POST), unlink_item_category(POST) |
| `api/batches/VirtualPurchasesController` | create（`X-Batch-Token` 認証） |
| `api/batches/MarketPriceFluctuationsController` | create（`X-Batch-Token` 認証） |
| `admin/WholesaleStocksController` | index, new, create, edit, update, destroy, export(CSV), import(CSV) |
| `admin/BatchesController` | market_price_fluctuation（管理者UIから手動実行） |

## ルーティング

```ruby
namespace :api do
  namespace :batches do
    post 'virtual_purchase',         to: 'virtual_purchases#create'
    post 'market_price_fluctuation', to: 'market_price_fluctuations#create'
  end
end

namespace :admin do
  post 'batches/market_price_fluctuation', to: 'batches#market_price_fluctuation'
  resources :wholesale_stocks, only: [:index, :new, :create, :edit, :update, :destroy] do
    collection do
      get  :export
      post :import
    end
  end
end

namespace :store do
  root to: "dashboard#index"
  get 'guide',           to: 'guide#index'
  get 'shopping_street', to: 'shopping_street#index'

  resources :towns, only: [:index, :new, :create] do
    get  'join_request', on: :collection
    get  'select',       on: :collection
    post 'join',         on: :collection
    post 'switch',       on: :collection
    get  'market',       on: :member
  end

  resources :stores, only: [:index, :show, :new, :create, :edit, :update] do
    resources :stocks, only: [:index, :create, :show, :edit, :update, :destroy] do
      member do
        get  :list
        post :list
        post :unlist
      end
      collection do
        get  :bulk_new
        get  :bulk_confirm
        post :bulk_create
      end
    end
    resources :recipes, only: [:index, :new, :create, :destroy] do
      post 'craft', on: :member
    end
  end

  resources :sales_logs,        only: [:index]
  resource  :bank,              only: [:show] do
    post :borrow
    post :repay
  end
  resource  :virtual_customer_batch, only: [:show, :create]
  resources :item_sub_categories, only: [:index, :new, :create] do
    post :import_master, on: :collection
  end
  resources :item_categories,  only: [:index, :new, :create, :edit, :update, :destroy]
  resources :buisiness_times,  only: [:index]
  resources :store_categories, only: [:index, :new, :create, :edit, :update, :destroy] do
    post :assign_item_category, on: :member
    post :unlink_item_category, on: :member
  end
  get  'other_stores', to: 'other_stores#index'
  resources :store_actions, only: [] do
    get  'buy',      on: :collection
    post 'buy',      on: :collection
    get  'purchase', on: :collection
    post 'purchase', on: :collection
    post 'sell',     on: :collection  # 未実装
  end
end
```

## バッチ認証

`Api::BatchesController` が `before_action :authenticate_batch_token!` を適用。

- リクエストヘッダー `X-Batch-Token` の値と環境変数 `BATCH_SECRET_TOKEN` を `SecureCompare` で比較
- `BATCH_SECRET_TOKEN` 未設定の場合は 500、不一致の場合は 401 を返してフィルタ停止
- Render 上では cron サービスと Web サービスの **両方** に `BATCH_SECRET_TOKEN` を設定する必要がある

## バッチスケジュール（render.yaml）

| バッチ名 | スケジュール | エンドポイント |
|---|---|---|
| virtual-customer-batch | `0 * * * *`（毎時0分） | POST /api/batches/virtual_purchase |
| market-price-fluctuation-batch | `30 1 * * *`（毎日1:30） | POST /api/batches/market_price_fluctuation |
