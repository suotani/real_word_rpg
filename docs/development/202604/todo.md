# 開発 TODO リスト

> 1 TODO = 1モデル × 1アクション

---

## 🔴 Critical

### StoreActionsController（新規作成）
- [ ] `StoreActionsController#buy` — 在庫購入トランザクション実装
- [ ] `StoreActionsController#sell` — 在庫販売トランザクション実装

### Stock ビュー
- [ ] `Stock` index ビュー作成（`app/views/store/stocks/index.html.haml`）
- [ ] `Stock` new ビュー作成（name / item_sub_category / cost / price フォーム）
- [ ] `Stock` edit ビュー作成
- [ ] `Stock` show ビュー作成

---

## 🟣 Recipe システム（新規）

### RecipesController（新規作成）
- [ ] `RecipesController#index` — ストアのレシピ一覧
- [ ] `RecipesController#new` / `#create` — レシピ作成（item_sub_category の複数選択）
- [ ] `RecipesController#edit` / `#update` — レシピ編集
- [ ] `RecipesController#destroy` — レシピ削除
- [ ] `RecipesController#craft` — レシピ実行（素材 Stock を消費して新 Stock を生成）

### Recipe ビュー
- [ ] `Recipe` index ビュー作成（`app/views/store/recipes/index.html.haml`）
- [ ] `Recipe` new/edit フォームビュー作成（`_form.html.haml`）

---

## 🟡 既存機能の修正

### StoresController
- [ ] `StoresController#destroy` — ストア削除アクション実装
- [ ] `Store#update` — 在庫が存在する場合に更新を禁止するバリデーション追加（TODO 解消）

---

## 🟠 レガシー整理

### Town
- [ ] `Town` モデルから `has_one :user` を削除

### User / Migration
- [ ] `users.town_id` カラム削除マイグレーション作成・実行

---

## 🔵 機能追加候補

### BuisinessTime
- [ ] `BuisinessTime` モデルに `belongs_to :item_category` アソシエーション追加
- [ ] `BuisinessTime` の管理 UI 設計・実装

### Town
- [ ] `TownsController#edit` / `#update` — タウン編集アクション実装
- [ ] `TownsController#destroy` — タウン削除アクション実装
