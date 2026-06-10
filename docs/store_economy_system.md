# タウン・ストアエコノミーシステム

ユーザーが仮想の街を作成・参加し、店舗を構えて在庫を管理するサービス。`store/` 名前空間で完結している。

## 概要

「タウン」を単位としたコミュニティに複数ユーザーが参加し、各自が「ストア（店舗）」を持ち在庫を管理する。在庫（Stock）はアイテム名と素材カテゴリ（ItemSubCategory）を直接持ち、製造コストと販売価格を管理する。ストアはレシピ（Recipe）を持ち、レシピが必要とする素材カテゴリに一致する在庫を消費して新たな在庫を生成できる。

## 経済フロー

```
[タウン作成]
  → 中央卸売市場（user_id: nil）が自動生成
  → 全 ItemSubCategory の初期在庫が price: 100円 で登録される

[仕入れ] StoreActions#buy
  → 市場の Stock を選択 → 自分の Store を選択 → 数量を入力
  → User.balance から price × quantity を deduct!
  → 自 Store に Stock を create!（cost = 市場の price）

[出品] Stocks#list
  → 販売価格を入力（1円以上）→ listed: true にする

[ユーザー間購入] StoreActions#purchase
  → 他ユーザーの出品中 Stock を選択 → 受け取り先 Store を選択
  → 購入者の balance から price を deduct!
  → 出品者の balance に price を increment!
  → 出品 Stock を destroy し、受け取り先 Store に新 Stock を create!

[仮想顧客バッチ] VirtualCustomerBatchJob
  → 全 listed Stock の出品者に price を自動付与 → Stock を destroy
  → POST /api/batches/virtual_purchase（X-Batch-Token 認証）でキューに投入
```

店舗カテゴリによる絞り込み：仕入れ・購入時、`item_sub_category → item_category → store_category` を遡って、同じ `store_category` を持つ自店舗のみ選択肢に表示する。

## ユーザーフロー

### 街の作成

1. `/store/towns/new` で街の名前を入力
2. 8文字の英数字パスワードが自動生成される
3. `Town`・`UserTown`（作成者分）が作成され、中央卸売市場が自動生成される
4. ダッシュボードにリダイレクト（パスワードが表示される）

### 街への参加

1. `/store/towns/join_request` で街の名前とパスワードを入力
2. 一致する `Town` が存在し、未参加であれば `UserTown` が作成される
3. `user.town` を新タウンに切り替え、参加後は市場・他店舗にアクセス可能

### 店舗の作成

1. `current_user.town` が設定済みであること（`stores#new` でチェック、なければ select へリダイレクト）
2. `/store/stores/new` で店舗名・カテゴリ（`卸市場` 以外）・テーマカラー2色を設定
3. `current_user.town` に紐づいて作成される

### 在庫の仕入れ（市場から）

1. `/store/towns/:id/market` で中央卸売市場の在庫一覧を表示（`ItemCategory` フィルタ対応）
2. 仕入れたい Stock を選択し `buy` アクションへ
3. 受け取り先の自店舗を選択 → 数量を指定 → 購入

### 在庫の出品と購入

1. 自店舗の在庫一覧（`stocks#index`）から「出品する」→ 価格設定（`stocks#list`）
2. 他ユーザーが `/store/stores/:id` で出品中在庫を確認し `purchase` で購入
3. 「取り消し」で `listed: false` に戻せる（`stocks#unlist`）

### レシピによる在庫生成（クラフト）

1. `/store/stores/:store_id/recipes/new` でレシピを作成
   - 生成する在庫名・出力 `ItemSubCategory`、素材となる `ItemSubCategory`（複数）を指定
2. `recipes#craft` でレシピを実行
   - `item_sub_category_id` が一致する Stock を各1個消費
   - 素材の cost 合計を cost とした新 Stock を生成（price: 0 で未出品状態）

> edit / update は first リリース対象外。変更したい場合は削除して再登録で対応。

## 注意事項

- ユーザーは複数の街に参加できる（`user_towns`）が、`current_user.town` が現在アクティブな街を示す（`TownsController#switch` で切り替え）
- `theme_color` と `theme_sub_color` は異なる値でなければならない（バリデーションあり）
- `BuisinessTime` はスペルミス（correct: BusinessTime）だが、既存のコードに合わせること
- `Item` / `Material` テーブルは新設計では不要。既存データがある場合はマイグレーションで移行または削除すること
- 中央卸売市場（`user_id: nil`）はシステム所有の Store。ユーザーが Store 一覧で取得する際は `current_user.stores` で除外される
## データモデル

### Town（街）

```
name      string   - 街の名前（ユニーク、最小2文字）
user_id   integer  - 作成者
password  string   - 参加パスワード（8文字英数字、自動生成）
```

- 作成者は `UserTown` レコードも同時に作成される

### UserTown（ユーザー↔街の中間テーブル）

```
user_id   integer
town_id   integer
```

### Store（店舗）

```
name              string  - 店舗名（街内でユニーク）
town_id           integer
user_id           integer
store_category_id integer
theme_color       string  - メインカラー (#RRGGBB)
theme_sub_color   string  - サブカラー (#RRGGBB、メインと異なる値が必要)
```

- `has_many :stocks`
- `has_many :recipes`

### Stock（在庫）

```
name                 string   - 在庫アイテム名
store_id             integer  optional  - NULLの場合は倉庫在庫
user_id              integer  optional  - NULLの場合はシステム在庫（中央卸売市場）
item_sub_category_id integer  optional  - 素材カテゴリの分類（レシピ照合・仕入れ先絞り込みに使用）
cost                 integer  - 仕入れ・製造コスト
price                integer  - 販売価格（出品時は 1円以上必須）
listed               boolean  - 出品中フラグ（true のとき他ユーザーが購入可能）
```

`Item` モデルは廃止。`Stock` が名前と素材カテゴリを直接持つ。

### ItemCategory / ItemSubCategory / StoreCategory（カテゴリ）

```
StoreCategory:    name                        例）飲食店
ItemCategory:     name, store_category_id     例）野菜、肉類、飲料
ItemSubCategory:  name, item_category_id      例）かぼちゃ、りんご（野菜の下）
```

`StoreCategory → ItemCategory → ItemSubCategory` という3段階の階層構造。`ItemSubCategory` がかぼちゃ・鶏肉など具体的な素材を表す最小単位。

- `Stock` は `item_sub_category_id` を持ち、その在庫がどの素材種別に属するかを示す
- レシピが必要とする `ItemSubCategory` と、ユーザーが保有する `Stock` の `item_sub_category_id` を照合することで、素材として使用可能な在庫を特定できる

### Recipe（レシピ）

```
store_id  integer  - レシピを持つ店舗
name      string   - レシピ名
```

- `Store` が `has_many :recipes`
- `Recipe` は `has_many :item_sub_categories, through: :recipe_item_sub_categories`

### RecipeItemSubCategory（レシピ↔サブカテゴリの中間テーブル）

```
recipe_id            integer
item_sub_category_id integer
```

レシピが必要とする素材カテゴリを管理する。レシピから在庫を作成する際は、`item_sub_category_id` が一致する `Stock` を素材として消費する。

### BuisinessTime（営業時間）

```
item_category_id  integer  - FK（DB 制約あり、モデルへのアソシエーション未実装）
sales_at          integer
```

### User（残高）

`User` モデルに `balance integer default: 0` カラムが存在する。仕入れ・購入時に `deduct!`、売却時に `increment!` で増減する。

## コントローラー

| コントローラー                          | 主なアクション                                                                    |
|----------------------------------------|----------------------------------------------------------------------------------|
| `store/DashboardController`             | index                                                                            |
| `store/TownsController`                 | index, new, create, select, switch, join_request, join, market                  |
| `store/StoresController`               | index, show, new, create, edit, update                                           |
| `store/StocksController`               | index, show, create, edit, update, destroy, list(GET/POST), unlist(POST)         |
| `store/RecipesController`              | index, new, create, destroy, craft                                                |
| `store/StoreActionsController`         | buy(GET/POST), purchase(GET/POST), sell(POST・未実装)                            |
| `store/OtherStoresController`          | index（同タウンの他ユーザー店舗一覧）                                             |
| `store/ItemSubCategoriesController`    | new, create                                                                      |
| `api/batches/VirtualPurchasesController` | create（バッチ起動、`X-Batch-Token` 認証）                                    |

※ `ItemsController` は `Item` モデル廃止に伴い削除。

## ルーティング（現在の実装）

```ruby
namespace :api do
  namespace :batches do
    post 'virtual_purchase', to: 'virtual_purchases#create'
  end
end

namespace :store do
  root to: "dashboard#index"
  get 'dashboard', to: 'dashboard#index'

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
    end
    resources :recipes, only: [:index, :new, :create, :destroy] do
      post 'craft', on: :member
    end
  end

  resources :item_sub_categories, only: [:new, :create]
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
