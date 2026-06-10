# 開発 TODO リスト

> 最終更新: 2026-06-08
> 1 TODO = 1モデル × 1アクション

---

## ✅ 完了済み

### StoreActionsController
- [x] `StoreActionsController#buy` — 中央卸売市場からの仕入れトランザクション
- [x] `StoreActionsController#purchase` — ユーザー間購入トランザクション（出品中在庫を他ユーザーが購入）

### Stock ビュー
- [x] `Stock` index ビュー（`store/stocks/index.html.haml`）
- [x] `Stock` list ビュー（出品価格入力フォーム、`store/stocks/list.html.haml`）

### Recipe システム
- [x] `RecipesController#index` — ストアのレシピ一覧
- [x] `RecipesController#new` / `#create` — レシピ作成（素材の複数選択）
- [x] `RecipesController#destroy` — レシピ削除
- [x] `RecipesController#craft` — レシピ実行（素材 Stock を消費して新 Stock を生成）
- [x] `Recipe` index ビュー（`store/recipes/index.html.haml`）
- [x] `Recipe` new フォームビュー（`store/recipes/new.html.haml`）

### その他（新規追加済み）
- [x] `OtherStoresController#index` — 同タウンの他ユーザー店舗一覧
- [x] `ItemSubCategoriesController#new` / `#create` — サブカテゴリ追加
- [x] `VirtualCustomerBatchService` / `VirtualCustomerBatchJob` — 仮想顧客バッチ（出品中在庫を自動売却）
- [x] `API::Batches::VirtualPurchasesController#create` — バッチ起動 API（`X-Batch-Token` 認証）

---

## 🔴 Critical（未着手）

### StoreActionsController
- [ ] `StoreActionsController#sell` — 自ユーザー在庫の売却アクション実装

### Stock ビュー
- [ ] `Stock` new ビュー（`store/stocks/new.html.haml`）— name / item_sub_category / cost / price フォーム
  - 注: ルートに `:new` が含まれていないため、ルート追加も必要
- [ ] `Stock` edit ビュー（`store/stocks/edit.html.haml`）
- [ ] `Stock` show ビュー（`store/stocks/show.html.haml`）

---

## 🟡 既存機能の修正

---

## 🟠 レガシー整理

### Town
- [ ] `Town` モデルから `has_one :user` を削除（`has_many :users, through: :user_towns` が正の関係）

### User / Migration
- [ ] `users.town_id` カラム削除マイグレーション作成・実行（スキーマ上まだ存在）

---

## 🔵 機能追加候補

### BuisinessTime
- [ ] `BuisinessTime` モデルに `belongs_to :item_category` アソシエーション追加（DB FK は存在済み）
- [ ] `BuisinessTime` の管理 UI 設計・実装（営業時間帯の設定画面）

### Town
- [ ] `TownsController#edit` / `#update` — タウン編集アクション実装（コントローラーにコメントアウト済み）
- [ ] `TownsController#destroy` — タウン削除アクション実装

---

## 📋 現在のシステム概要（2026-06-08 時点）

### 経済フロー
1. タウン作成時に **中央卸売市場** が自動生成（`ItemSubCategory` ごとに初期在庫 100円）
2. ユーザーは市場から **仕入れ**（`StoreActions#buy`）→ 自店舗 Stock に追加
3. Stock を **出品**（`Stocks#list`）→ 他ユーザーが **購入**（`StoreActions#purchase`）
4. **仮想顧客バッチ**（`VirtualCustomerBatchJob`）が定期実行され、出品中 Stock を自動売却

### レシピ（クラフト）
- 素材となる `ItemSubCategory` を複数指定してレシピを登録
- 在庫に素材が揃っていれば `craft` アクションで合成 → 新 Stock 生成

### 店舗カテゴリと商品カテゴリの対応
- `StoreCategory` → `ItemCategory` → `ItemSubCategory` の 3 階層
- 仕入れ・購入時に店舗カテゴリで絞り込み（異業種間の仕入れを防止）
