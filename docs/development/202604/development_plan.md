# ストアサービス 開発状況整理（2026年4月時点）

## 実装済みの機能

### タウン
- タウン一覧表示
- タウン作成（パスワード自動生成）
- タウン参加（名前 + パスワードで認証）

### ストア
- ストア一覧表示
- ストア作成（テーマカラー2色、カテゴリ設定）
- ストア編集・更新

### アイテム
- アイテム一覧表示（ページネーション付き）
- アイテム詳細表示
- アイテム作成・編集

### 在庫（Stock）
- 在庫作成（コスト・価格・ストア割り当て）
- 在庫一覧（ストアIDでフィルタ可能）

---

## 開発が必要な部分

### 🔴 Critical：動作しない・ルートが未定義

#### 売買機能（store_actions）
- `store_actions#buy` / `store_actions#sell` のルートは定義済みだが、コントローラー自体が存在しない
- 在庫の購入・販売トランザクション、在庫数チェック、決済処理がすべて未実装
- ストアサービスのコアとなる機能のため最優先

#### ビューファイルが存在しない
| 画面 | パス |
|------|------|
| ストア詳細 | `app/views/store/stores/show.html.haml` |
| ストア一覧 | `app/views/store/stores/index.html.haml` |
| 在庫一覧 | `app/views/store/stocks/index.html.haml` |
| 在庫編集 | `app/views/store/stocks/edit.html.haml` |

#### ルーティング未定義のコントローラーアクション
- `StocksController#edit` / `#update` / `#destroy` — コントローラーに実装はあるが routes に含まれていない
- `StoresController#destroy` — 同上

---

### 🟡 Partial：実装が不完全

#### TODOが残っているロジック
- `StoresController#update` に `# TODO: 更新するときは商品は空の状態のみ` のコメントあり
  - 在庫が存在する場合にストア更新を禁止するバリデーションが未実装

---

### 🟠 Schema/モデルの不整合・削除対象

| 問題 | 詳細 |
|------|------|
| `users` テーブルに `town_id` カラムあり | `user_towns` の多対多で管理しているため用途が不明。レガシーカラムの可能性あり |
| `Town` に `has_one :user` と `has_many :users, through: :user_towns` が共存 | 前者はレガシーの可能性が高い |
| `BuisinessTime` モデルが空 | スキーマには `item_category_id` / `sales_at` カラムがあるが、アソシエーションもロジックも未定義 |
| **`Item` モデル・テーブル** | 新設計で `Stock` が名前と `item_sub_category_id` を直接持つため不要。削除対象 |
| **`Material` モデル・テーブル** | `Recipe / RecipeItemSubCategory` に置き換えられるため不要。削除対象 |
| **`ItemsController`** | `Item` 廃止に伴い削除対象 |

---

### 🔵 今後の機能追加候補

- **営業時間管理（BuisinessTime）** — モデル・テーブルは存在するが完全未実装
- **ストアページでのアイテム閲覧** — ストア単位でアイテムを絞り込む画面がない
- **タウン管理（編集・削除）** — `TownsController` にコメントアウトされた edit/update/destroy が存在

---

### 🟣 新規設計：サブカテゴリ・レシピシステム

#### 追加するモデル

| モデル | 概要 |
|--------|------|
| `ItemSubCategory` | `ItemCategory` の下位区分。`item_category_id` を持つ |
| `Recipe` | `Store` に紐づくレシピ。`store_id` と `name` を持つ |
| `RecipeItemSubCategory` | `Recipe` と `ItemSubCategory` の多対多中間テーブル |

#### Stockへの変更

- `Item` モデル・テーブルを廃止し、`Stock` が `name` を直接持つ
- `stocks` テーブルに `name` / `item_sub_category_id` を追加、`item_id` を削除
- `Stock` モデルに `belongs_to :item_sub_category, optional: true` を追加

#### カテゴリ階層

```
StoreCategory → ItemCategory → ItemSubCategory
```

#### レシピによる在庫作成フロー

1. `Recipe` が必要とする `ItemSubCategory` を `RecipeItemSubCategory` で定義
2. レシピ実行（craft）時、`item_sub_category_id` に一致する `Stock` を素材として自動照合
3. 素材 `Stock` を消費して新しい `Stock` を生成する

#### 必要な実装作業

| 作業 | 内容 |
|------|------|
| マイグレーション | `item_sub_categories`、`recipes`、`recipe_item_sub_categories` テーブル作成。`stocks` に `name` / `item_sub_category_id` 追加・`item_id` 削除。`items` / `materials` テーブル削除 |
| モデル | `ItemSubCategory`、`Recipe`、`RecipeItemSubCategory` 作成。`Stock` を `name` + `item_sub_category_id` 持ちに変更。`Item` / `Material` モデル削除 |
| コントローラー | `store/RecipesController`（CRUD + craft アクション）。`ItemsController` 削除 |
| ビュー | レシピ管理画面、在庫作成画面（名前・サブカテゴリ入力）。アイテム関連ビュー削除 |

---

## 優先度まとめ

| 優先度 | タスク |
|--------|--------|
| 1 | `StoreActionsController` の作成（buy / sell） |
| 2 | 不足しているビューファイルの作成（stores/show, stores/index, stocks/index, stocks/edit） |
| 3 | ルーティングへの追加（stocks: edit/update/destroy、stores: destroy） |
| 4 | ストア更新時のバリデーション実装（TODO解消） |
| 5 | サブカテゴリ・レシピシステムの実装（`ItemSubCategory` / `Recipe` / `RecipeItemSubCategory`） |
| 6 | `Item` / `Material` の廃止マイグレーション、`Stock` への `name` 追加 |
| 7 | `BuisinessTime` の設計・実装 |
| 8 | `users.town_id` / `Town#has_one :user` のレガシーコード整理 |
