# 開発 TODO リスト（2026-06）

> 最終更新: 2026-06-08

---

## 🔴 優先

### 中央卸売市場


### カテゴリ整合性
- [ ] 商品カテゴリ（ItemCategory）と店舗カテゴリ（StoreCategory）の紐付けバリデーション追加
  - 仕入れ・購入時の store_category 絞り込みは実装済みだが、Stock 作成時のバリデーションがない
- 
---

## 🟡 バッチ・仮想購入

- [ ] `VirtualCustomerBatchJob` に店舗カテゴリ別の購入時間帯フィルタを組み込む
  - `BuisinessTime`（item_category_id / sales_at）を活用
  - `BuisinessTime` モデルに `belongs_to :item_category` 追加（DB FK は存在済み）
  - 店舗カテゴリには売れる時間帯が複数ある想定。例えば、飲食店は12時と19時、青果店は16時など
  - 管理 UI で営業時間帯を設定できるようにする
  - フロー
    - 購入者を20人用意し、ランダムに所持金を持たせる
    - その時間帯でから店舗カテゴリを絞り込む。
    - その店舗の商品一覧を取得
    - 商品毎に魅力度(= 仕入れ/販売価格)を算出し、高い物から並び替え
    - 購入者をループし、魅力度が高い物から購入する。
    - 買えなかったらスキップ
- [ ] 深夜1時バッチで前日の売買サマリーを作成・保存する
  - どうやってデータ保存するか確認

---

## 🟠 積み残し（202604 から）

### Stock ビュー・ルート
- [ ] `stocks` ルートに `:new` を追加（現在 `only:` に `:new` が欠けている）
- [ ] `Stock` new ビュー作成（`store/stocks/new.html.haml`）
- [ ] `Stock` edit ビュー作成（`store/stocks/edit.html.haml`）
- [ ] `Stock` show ビュー作成（`store/stocks/show.html.haml`）

### StoresController
- [ ] `StoresController#destroy` 実装（在庫が残っている場合はエラー）
- [ ] `Store#update` — 在庫が存在する場合は更新禁止バリデーション追加

### StoreActionsController
- [ ] `StoreActionsController#sell` — 自店舗在庫の売却アクション実装

### レガシー整理
- [ ] `Town` モデルから `has_one :user` を削除
- [ ] `users.town_id` カラム削除マイグレーション作成・実行

---

## 🔵 機能追加候補

- [ ] 市場の初期 Stock 価格を ItemSubCategory 単位で設定できるようにする（現在一律 100円）

店舗開業時のコスト
初期所持金
借入