# 従業員（Employee）機能 実装方針（2026年9月）

## 背景・目的

現在ストアには在庫（Stock）・レシピ（Recipe）はあるが、店舗を「強化」する要素がない。ユーザーがお金を使って店舗に従業員を雇い、種別ごとの効果（魅力度アップ、仕入れ割引、バッチ来客数アップ等）を得られるようにすることで、経済ゲームとしての選択肢と資金の使い道を増やす。

要件は以下の4点：

- お金を払って従業員を雇える
- 雇用は店舗ごとに常に1人まで。変更（雇い直し）のたびにその従業員種別分の費用がかかる
- 従業員の種別ごとに能力が異なる（例: 看板娘＝商品魅力度アップ＋バッチごとの来客数アップ、せり人＝仕入れ値一律3%off）
- 一度支払えば、次に変更するまで効果は使い続けられる（都度課金ではない）

この機能は改修範囲が大きいため、まずは実装方針のみを固める。**コードの実装はまだ行わない。**

## データモデル

### `EmployeeType`（従業員種別マスタ、新規テーブル）

`ItemCategory`/`StoreCategory` と同じ「マスタデータ」の位置づけ。将来種別を増やしやすいよう、効果は具体的なカラムとして持つ（Stock の `ingredient_count`/`unsold_count` と同様、汎用エフェクトエンジンは作らない）。

```
name                             string   一意。例: 看板娘、せり人
hire_cost                        integer  雇用時に一度だけ支払う金額
attractiveness_bonus             float    default 0.0   Stock#calculate_attractiveness に加算
purchase_discount_rate           float    default 0.0   仕入れ値の割引率（0.03 = 3%off）
extra_customer_count             integer  default 0     バッチごとの追加来客数（その店舗専用）
bonus_customer_balance_multiplier float   default 1.0   上記の追加来客の所持金レンジに掛ける倍率
virtual_sale_bonus_rate          float    default 0.0   仮想顧客への販売額に乗せる上乗せ率（0.05 = 5%up）
description                      text     一覧表示用の説明（任意）
```

### 雇用状態は `Store` に直接持たせる（`Employee` テーブルは作らない）

当初は雇用履歴を残す別テーブル（`Employee`）を想定していたが、以下の理由で不要と判断し、`stores.employee_type_id` に一本化する。

- 「誰が雇ったか」は `store.user_id`（店舗オーナー）から判明するので、別途 `user_id` を持つ必要がない
- 雇用時点の金額を記録する要件（後から `hire_cost` が変わっても過去の支払額を追跡したい、等）はないので `paid_amount` も不要
- 履歴を見る・保持するという要件自体がないため、現在の1件だけを持てば十分

`stores` テーブルに追加するカラム：

```
employee_type_id   references, null: true, foreign_key: true   現在雇用中の従業員種別（未雇用なら nil）
```

### `Store` への追加

```ruby
belongs_to :employee_type, optional: true

def hire_employee!(user, new_employee_type)
  raise ArgumentError, "所持金が不足しています（必要: #{new_employee_type.hire_cost}円 / 所持: #{user.balance}円）" unless user.afford?(new_employee_type.hire_cost)
  ActiveRecord::Base.transaction do
    update!(employee_type: new_employee_type)
    user.deduct!(new_employee_type.hire_cost)
  end
end

def dismiss_employee!
  update!(employee_type: nil)
end
```

`User#borrow!`/`repay!`（`app/models/user.rb`）と同じ「業務ロジックは bang メソッド＋ArgumentError、コントローラは rescue するだけ」のパターンを踏襲する。

`EmployeeType` 側には `has_many :stores, dependent: :restrict_with_error` を追加する（雇用中の店舗がある種別は削除できないようにする）。

## コントローラー・ルーティング

### 雇用フロー: `Store::EmployeeController`（`stores` にネストした単数リソース）

一般ユーザー向けの「雇える従業員種別一覧」は、この雇用画面（`show`アクション）の中で `EmployeeType.order(:hire_cost)` を表示すれば足りるため、こちらも別途一覧ページは作らない。

店舗ごとに雇用枠は常に1つ（＝`store.employee_type_id`）なので、複数形の `employees` ではなく単数形の `resource :employee` としてネストする。

```ruby
resources :stores, ... do
  resource :employee, only: [:show, :create, :destroy]
end
```

- `show`: `@store`, `@employee_types = EmployeeType.order(:hire_cost)` を表示（現在の従業員は `@store.employee_type` で分かる）。オーナーのみアクセス可（`current_user.stores.find` で scoping、`stocks_controller` と同じ）
- `create`: `params[:employee_type_id]` を受け取り `@store.hire_employee!(current_user, employee_type)` を呼び、`ArgumentError` を rescue して alert 表示（`banks_controller` と同じ形）
- `destroy`（解雇、無料）: `@store.dismiss_employee!`

## 効果の適用ポイント（4箇所）

1. **魅力度ボーナス** — `app/models/stock.rb#calculate_attractiveness`
   ```ruby
   (base_price.to_f / price) + ingredient_count.to_i * INGREDIENT_WEIGHT + store&.employee_type&.attractiveness_bonus.to_f
   ```

2. **仕入れ割引** — `app/controllers/store/store_actions_controller.rb#buy`
   `total_cost` 計算に `destination_store.employee_type&.purchase_discount_rate.to_f` を反映（例: `(price * quantity * (1 - rate)).round`）。

3. **バッチ来客数アップ＋ボーナス客の予算引き上げ** — `app/services/virtual_customer_batch_service.rb`（最も影響が大きい変更）
   現状 `purchase_for_town` は町内の全店舗の出品在庫を1つのプールにまとめ、共通の仮想購入者20人（所持金 `BALANCE_RANGE`）が魅力度順に購入する実装。「看板娘のいる店舗だけ来客数が増える」を素直に実装するなら、共有プールの人数自体を増やすと町内の他店舗まで恩恵を受けてしまう。
   → **その店舗の在庫だけを対象にした追加ウェーブ**を、共通プールの購入処理が終わった後に走らせる方式にする。
   - 内部の「購入者リストと在庫プールを受け取って購入処理する」ロジックを private メソッドとして切り出し、共通プール用と店舗専用ボーナスウェーブ用の両方から呼べるようにする
   - ボーナスウェーブは「共通プールで売れ残った、その店舗自身の出品在庫」だけを対象にする（他店舗の在庫には影響しない）
   - ボーナスウェーブの購入者の所持金は `BALANCE_RANGE` に `bonus_customer_balance_multiplier` を掛けた範囲で生成する（客数だけでなく、1人あたりの購買力も上げられる）
   - `MIN_ATTRACTIVENESS` 等の既存ルールはボーナスウェーブでも同様に適用する

4. **仮想購入時の売上ブースト** — `app/services/virtual_customer_batch_service.rb`（`purchase_for_town` 内の購入処理）
   仮想顧客に売れた際の売上・残高加算額に `virtual_sale_bonus_rate` を上乗せする（ユーザー間購入には適用しない、仮想顧客バッチ限定の効果）。
   ```ruby
   bonus_rate  = stock.store&.employee_type&.virtual_sale_bonus_rate.to_f
   sale_amount = (live.price * (1 + bonus_rate)).round
   live.user&.increment!(:balance, sale_amount)
   SalesLog.record_sale!(live.user, sale_amount, live.cost)
   ```
   `stocks_by_town`/`all_listed` の取得時に `store` を eager load しておく（`includes(:user, :store)`）。

## マイグレーション

```ruby
create_table :employee_types do |t|
  t.string  :name, null: false
  t.integer :hire_cost, null: false, default: 0
  t.float   :attractiveness_bonus, null: false, default: 0.0
  t.float   :purchase_discount_rate, null: false, default: 0.0
  t.integer :extra_customer_count, null: false, default: 0
  t.text    :description
  t.timestamps
end
add_index :employee_types, :name, unique: true

add_reference :stores, :employee_type, null: true, foreign_key: true
```

## 画面

- `app/views/store/stores/show.html.haml` に「従業員」カードを追加。既存の「出品中の商品」カードと同じ見た目（`.card.border-0.shadow-sm`＋テーマカラーのグラデーションヘッダー）。既にある未使用の `@is_owner`（`stores_controller.rb#show`）で、雇用・解雇の操作はオーナーにのみ表示する。
- `app/views/store/employees/show.html.haml`（新規）: 現在の従業員（いれば効果と「解雇する」ボタン）＋従業員種別一覧（`admin/wholesale_stocks/index` のようなテーブル or カード、各行に「雇う」ボタン）
- 従業員種別マスタの管理画面は新規に作らず、既存の `/admin/resources/EmployeeType`（汎用CRUD）をそのまま使う

## 実装ステップ（PRを2つに分割することを推奨）

**PR1: データモデル・雇用フロー**（ゲームへの影響なし、雇っても効果はまだ出ない状態）
1. マイグレーション（`employee_types` 作成、`stores.employee_type_id` 追加）
2. `EmployeeType` モデル（`has_many :stores, dependent: :restrict_with_error`）、`Store` への `belongs_to :employee_type` と業務メソッド（`hire_employee!`/`dismiss_employee!`）追加 → この時点で `/admin/resources/EmployeeType` から従業員種別マスタを管理できる
3. `Store::EmployeeController`（単数リソース） + ビュー、`stores/show.html.haml` への従業員カード追加
4. ルーティング追加
5. モデルspec・request spec

**PR2: 効果の適用**（既存の経済ロジックに手を入れるため分離してリスクを下げる）
1. `Stock#calculate_attractiveness` に魅力度ボーナスを追加
2. `Store::StoreActionsController#buy` に仕入れ割引を追加
3. `VirtualCustomerBatchService` のリファクタリング＋店舗専用ボーナスウェーブ（客数アップ・所持金倍率）の追加
4. `VirtualCustomerBatchService` の購入処理に仮想購入時の売上ブーストを追加
5. 既存spec（`stock_attractiveness_spec.rb`, `virtual_customer_batch_service_spec.rb` 等）の更新＋新規spec

## 検証方法（実装時）

- `bundle exec rspec` で全体のリグレッションがないことを確認（現状 121 examples 全成功が基準）
- 新規モデル・コントローラのspecを追加（費用不足時のエラー、雇い直し時に `employee_type_id` が新しい種別に置き換わること、魅力度ボーナス加算、仕入れ割引適用、バッチの追加ウェーブが該当店舗のみに効くこと、ボーナス客の所持金倍率が反映されること、仮想購入時の売上ブースト率が反映されること）
- `spec/scenario/store_scenario_spec.rb` は既存フローを壊さないことを流して確認（新機能自体のシナリオ追加は任意）

## 未着手事項

上記はあくまで方針。実装（マイグレーション作成・コード変更）は本ドキュメントの合意後、別途着手する。
