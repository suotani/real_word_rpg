# 魅力度計算に基本料金（base_price）を使う実装方針（2026年9月）

## 背景

現在 `Stock` は以下の3つの金額系フィールドを持つ。

| フィールド | 意味 | 現状の扱い |
|---|---|---|
| `cost`（買値） | 仕入れにかかった金額 | 仕入れ・クラフトのタイミングで確定し、以降変化しない |
| `base_price`（基本料金） | 商品の基準となる価値 | 中央卸売市場では価格変動の基準値。プレイヤー在庫では、本来「仕入れた時点の価値」を表すべきだが、後述の通り実装上意味を失っている |
| `price`（販売価格） | 実際に売る値段 | 仕入れ時は買値と同額。出品時にプレイヤーが自由に設定できる |

魅力度（`Stock#calculate_attractiveness`, `app/models/stock.rb:15-19`）は現状こう定義されている。

```ruby
# 魅力度 = (仕入れ値 ÷ 販売価格) + 素材数 × 0.1
def calculate_attractiveness
  return 0.0 if price.to_i <= 0
  (cost.to_f / price) + ingredient_count.to_i * INGREDIENT_WEIGHT
end
```

分子は `cost`（買値）であり `base_price` は計算に一切使われていない。それどころか、出品時に `base_price` は**その場で決めた販売価格で上書き**されてしまう。

- `Store::StocksController#list`（`app/controllers/store/stocks_controller.rb:53`）
  ```ruby
  @stock.update!(price: price, base_price: price, listed: true)
  ```
- `Store::StocksController#bulk_create`（同ファイル `:93`）
  ```ruby
  stock.update!(price: price, base_price: price, listed: true)
  ```

このため、出品した瞬間は必ず `base_price == price`（比率1.0）になり、「仕入れた時の価値」という情報は出品時点で失われる。加えてクラフト時（`Store::RecipesController#craft`, `app/controllers/store/recipes_controller.rb:66-73`）は `base_price: 0` を固定で入れており、材料の価値は一切引き継がれない。

一方 `Store::StoreActionsController#buy`（`app/controllers/store/store_actions_controller.rb:31-38`）では、市場から仕入れた瞬間は

```ruby
destination_store.stocks.create!(
  ...
  cost:       @target_stock.price,   # 仕入れた瞬間の市場価格（変動あり）
  base_price: @target_stock.price,   # 同上
  price:      @target_stock.price
)
```

となっており、`cost` と `base_price` は仕入れ時点では同じ「変動後の市場価格」を記録している。つまり `base_price` は「その商品を買った瞬間、市場がいくらだったか」という意味を持てるフィールドであり、これは中央卸売市場の価格変動（`MarketPriceFluctuationService`）によって高い時・安い時が生まれる値である。この情報自体は仕入れ時に正しく記録されているが、**出品・クラフトの過程で潰されてしまっている**のが現状の問題。

## 目的

「仕入れた時の基本料金」を出品・クラフトを経ても保持し、魅力度計算に使う。結果として：

- 高い時（市場価格が高騰している時）に仕入れると、`base_price` が高い値で記録される → 販売価格を抑えないと魅力度が上がらない
- 安い時（市場価格が下落している時）に仕入れると、`base_price` が低い値で記録される → 多少高い販売価格を付けても魅力度を保ちやすい

これにより「安く仕入れて高く売る」トレーディング的な駆け引きが魅力度システムに反映される。

## 設計方針

### 1. 魅力度の計算式を `cost` から `base_price` に変更する

`app/models/stock.rb`

```ruby
# 魅力度 = (基本料金 ÷ 販売価格) + 素材数 × 0.1
def calculate_attractiveness
  return 0.0 if price.to_i <= 0
  (base_price.to_f / price) + ingredient_count.to_i * INGREDIENT_WEIGHT
end
```

`cost` は「実際に支払った金額」として利益計算（`SalesLog.record_sale!` 等）に残すが、魅力度の計算からは外す。

### 2. 出品時に `base_price` を上書きしないようにする

`Store::StocksController#list` / `#bulk_create` から `base_price: price` の指定を削除し、`price` と `listed` のみ更新する。

```ruby
# list
@stock.update!(price: price, listed: true)

# bulk_create
stock.update!(price: price, listed: true)
```

これにより「仕入れた時点の基本料金」がそのまま出品後も保持される。`bulk_create` は同名・同時刻に限らず複数の在庫をまとめて出品できるため、仕入れタイミングが異なる在庫が混在する場合、同じ販売価格でも在庫ごとに魅力度が変わる（仕入れが安かったものほど魅力度が高くなる）という自然な挙動になる。

なお `Store::StocksController#create`（手動での在庫追加）は市場やレシピを経由しない直接入力のため、現状通り `base_price: stock_params[:price]`（登録時点の価格を基準値とする）のままで問題ない。

### 3. レシピでクラフトした商品の `base_price` を材料の合計にする

`Store::RecipesController#craft`（`app/controllers/store/recipes_controller.rb:61-75`）で、材料の `cost` 合計だけでなく `base_price` 合計も計算し、生成する `Stock` に設定する。

```ruby
quantity.times do |i|
  batch_stocks = ingredient_ids.map { |id| stocks_by_ingredient[id][i] }
  total_cost       = batch_stocks.sum(&:cost)
  total_base_price = batch_stocks.sum(&:base_price)
  batch_stocks.each(&:destroy!)
  @store.stocks.create!(
    name: @recipe.name,
    cost: total_cost,
    base_price: total_base_price,
    price: 0,
    user: current_user,
    ingredient_count: batch_stocks.size
  )
end
```

材料を安く仕入れて加工した商品は `base_price` も低く抑えられ、出品時に高値を付けても魅力度を保ちやすくなる。逆に高い材料を使うと `base_price` が高くなり、値付けを抑えないと魅力度が上がらない。これは狙っている「仕入れ値が最終商品の魅力度に反映される」という要件と直接一致する。

### 4. コメント・ドキュメントの整合

- `app/models/stock.rb:14` のコメントを `# 魅力度 = (基本料金 ÷ 販売価格) + 素材数 × 0.1` に修正
- `app/services/virtual_customer_batch_service.rb:40` のコメント（`仕入れ値 ÷ 販売価格`）も同様に修正
  - 併せて、このコメントには実装されていない `- 売れ残り回数 × 0.05` という記述が残っている（stale）。今回のスコープでは実装しないが、コメントは実態に合わせて削除しておく

## 変更しない箇所（検討したが不要と判断）

- **`Store::StoreActionsController#buy`**：`base_price: @target_stock.price` のまま変更不要。「仕入れた瞬間の市場価格」を記録する現状の実装が、そのまま「高い時に買うと基本料金が高く記録される」という要件を満たしている。市場側の恒常的な基準値（`central_wholesale_market` の `Stock#base_price`）をコピーしてしまうと、変動タイミングの影響が消えてしまい要件を満たせなくなるため、意図的に据え置く。
- **`Admin::WholesaleStocksController`**：中央卸売市場（供給元）側の `base_price` はそのまま「市場の基準価格＝価格変動の中心値」という既存の意味で使い続ける。プレイヤー在庫の魅力度計算とは別の役割なので変更不要。
- **`MIN_ATTRACTIVENESS`（`VirtualCustomerBatchService::MIN_ATTRACTIVENESS = 0.5`）**：計算式の分子を `cost` から `base_price` に変えても、仕入れ直後は両者が同値のため既存在庫のスコア分布は大きく変わらない。運用しながら閾値の調整要否を見る。

## 影響範囲・既知の制約

- **スキーマ変更なし**：`base_price` カラムは既に存在する（`db/migrate/20260915033954_add_base_price_to_stocks.rb`）ため、マイグレーションは不要。

## 既存レコードへの対応（データ補正）

既存の `Stock` レコードには、以下2パターンの「壊れた `base_price`」が存在する。

1. **出品済み在庫**：`base_price` を追加した `20260915033954_add_base_price_to_stocks.rb` が `UPDATE stocks SET base_price = price` で初期値を入れており、かつ旧 `list` / `bulk_create` が出品のたびに `base_price` を販売価格で上書きし続けていたため、これまでに一度でも出品された在庫は `base_price == price` になっている（＝仕入れ値の情報が失われている）。
2. **クラフト済み・未出品の在庫**：旧 `craft` アクションが `base_price: 0` を固定で入れていたため、`base_price == 0` のまま止まっている。

どちらのケースも、`cost`（買値・材料費合計）フィールドは一切上書きされずに正しい値を保持し続けている。したがって、**`cost` を「その在庫が仕入れられた時点の基本料金」の代替値として `base_price` に補正する**のが最も安全で一貫した復旧方法である。

- 中央卸売市場などの卸売在庫（`user_id: nil`）は対象外とする。市場側の `base_price` は「価格変動の基準値」という別の意味を持ち、`cost` とは無関係のフィールドのため、誤って書き換えないよう明示的に除外する。
- 対象は「プレイヤー在庫（`user_id` が設定されている）かつ `base_price != cost`」の行のみ。すでに正しい状態（仕入れ直後で未出品など）の行は `base_price == cost` のため対象にならず、何度実行しても副作用がない（冪等）。
- 出品済み在庫を補正すると、補正直後の魅力度は旧計算式（`cost / price`）の値と完全に一致する。つまりこの移行では、既存の出品中在庫の魅力度は変化せず、以後の新しい仕入れ・出品・クラフトから新しい仕様が効いてくる。

補正用スクリプトを `lib/tasks/stocks.rake`（`stocks:backfill_base_price`）として用意した。

```bash
# 対象件数と補正内容を確認するだけ（更新はしない）
DRY_RUN=1 bin/rails stocks:backfill_base_price

# 実際に補正する
bin/rails stocks:backfill_base_price
```

処理内容：
1. `Stock.where.not(user_id: nil).where.not('base_price = cost')` で対象を抽出
2. 各レコードの `base_price` を `cost` に更新
3. `listed: true` のレコードは合わせて `recalculate_attractiveness!` で `attractiveness` カラムも再計算

本番適用時はコードのデプロイ後、1回だけ実行すればよい（Render 環境であれば `bin/render-build.sh` 経由の自動マイグレーションとは別に、デプロイ後に手動で1度実行する想定）。

## 実装ステップ

1. `app/models/stock.rb`：`calculate_attractiveness` を `base_price` ベースに変更し、コメントを修正
2. `app/controllers/store/stocks_controller.rb`：`list` / `bulk_create` から `base_price: price` の上書きを削除
3. `app/controllers/store/recipes_controller.rb`：`craft` で材料の `base_price` 合計を計算し、生成する在庫に設定
4. `app/services/virtual_customer_batch_service.rb`：コメントの記述を実態に合わせて修正
5. 関連テスト（Stock の魅力度計算、出品フロー、クラフトフロー）を確認・追加
6. `lib/tasks/stocks.rake`（`stocks:backfill_base_price`）を追加し、デプロイ後に既存レコードの `base_price` を補正する

## テスト観点

- `Stock#calculate_attractiveness` が `base_price / price + ingredient_count * 0.1` を返すこと
- `list` / `bulk_create` 実行後も `base_price` が変化しないこと（`price` のみ更新されること）
- クラフト後の在庫の `base_price` が、消費した材料の `base_price` 合計と一致すること
- 高い市場価格で仕入れた在庫は、同じ販売価格でも安く仕入れた在庫より魅力度が低くなること（仕入れタイミングによる魅力度の差を確認する回帰テスト）
