# タウン・ストアエコノミーシステム

ユーザーが仮想の街を作成・参加し、店舗を構えて在庫を管理するサービス。`store/` 名前空間で完結している。

## 概要

「タウン」を単位としたコミュニティに複数ユーザーが参加し、各自が「ストア（店舗）」を持ち在庫を管理する。在庫（Stock）はアイテム名と素材カテゴリ（ItemSubCategory）を直接持ち、製造コストと販売価格を管理する。ストアはレシピ（Recipe）を持ち、レシピが必要とする素材カテゴリに一致する在庫を消費して新たな在庫を生成できる。

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
name                 string   - 在庫アイテム名（store_id + user_id スコープでユニーク）
store_id             integer  optional  - NULLの場合は倉庫在庫
user_id              integer
item_sub_category_id integer  optional  - 素材カテゴリの分類（レシピ照合に使用）
cost                 integer  - 仕入れ・製造コスト
price                integer  - 販売価格
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
item_category_id  integer
sales_at          integer
```

## コントローラー

| コントローラー               | 主なアクション                                   |
|-----------------------------|-------------------------------------------------|
| `store/DashboardController`  | index（ストアダッシュボード）                   |
| `store/TownsController`      | index, new, create, join_request, join          |
| `store/StoresController`     | index, new, create, edit, update                |
| `store/StocksController`     | index, new, create, edit, update, destroy       |
| `store/RecipesController`    | index, new, create, edit, update, destroy       |

※ `ItemsController` は `Item` モデル廃止に伴い削除。

## ルーティング

```ruby
namespace :store do
  root to: "dashboard#index"
  get 'dashboard', to: 'dashboard#index'
  resources :towns, only: [:index, :new, :create] do
    get  'join_request', on: :collection
    post 'join',         on: :collection
  end
  resources :stores, only: [:index, :new, :create, :edit, :update]
  resources :stocks
  resources :recipes do
    post 'craft', on: :member  # レシピから在庫を生成
  end
  resources :store_actions do
    post 'buy',  on: :collection
    post 'sell', on: :collection
  end
end
```

## ユーザーフロー

### 街の作成

1. `/store/towns/new` で街の名前を入力
2. 8文字の英数字パスワードが自動生成される
3. `Town` と `UserTown`（作成者分）が作成される
4. ダッシュボードにリダイレクト（パスワードが表示される）

### 街への参加

1. `/store/towns/join_request` で街の名前とパスワードを入力
2. 一致する `Town` が存在すれば `UserTown` が作成される
3. 参加後は街内のストア・在庫にアクセス可能

### 店舗の作成

1. 最低1つの街に参加済みであること（`stores#new` で確認）
2. `/store/stores/new` で店舗名・カテゴリ・テーマカラー2色を設定
3. ユーザーの最初の所属タウンに紐づいて作成

### 在庫の管理

1. `/store/stocks/new` で在庫を直接登録
   - 在庫名・`ItemSubCategory`・仕入れコスト・販売価格を入力
   - `store_id` を指定すれば店舗在庫、未指定なら倉庫在庫
2. `/store/stocks` で在庫一覧を表示

### レシピによる在庫生成

1. `/store/recipes/new` でレシピを作成（店舗に紐づく）
   - 必要な `ItemSubCategory` と数量を複数指定
2. `/store/recipes/:id/craft` でレシピを実行
   - 指定した `item_sub_category_id` に一致する `Stock` を自動照合
   - 素材 `Stock` を消費し、新しい `Stock` を生成

## 注意事項

- ユーザーは複数の街に参加できる（`user_towns`）が、ストア・在庫作成時は「最初の所属タウン」に紐づく
- `theme_color` と `theme_sub_color` は異なる値でなければならない（バリデーションあり）
- `BuisinesTime` はスペルミス（correct: BusinessTime）だが、既存のコードに合わせること
- `Item` / `Material` テーブルは新設計では不要。既存データがある場合はマイグレーションで移行または削除すること
