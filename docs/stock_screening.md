# 割安株スクリーニング

日経225全構成銘柄を対象に、「銘柄自身の過去の中で割安(低PBR)だった時期ほど、その後の
株価が上がりやすいか」という自分史ベースの相関を使い、現時点で候補になる銘柄を抽出する
分析結果を保存・閲覧する機能(別リポジトリ`~/finance/stocks`の分析パイプラインの成果物を
取り込むもの)。

## 仕組み

- データ取得・分析はこのRailsアプリの中では行わない。`finance/stocks`リポジトリの
  `find_undervalued_stocks.rb`をローカルで実行すると、Yahoo Finance(価格)とJ-Quants API
  (ファンダメンタルズ)から日経225・225銘柄分のデータを取得し、`data/current_buy_candidates.json`
  を生成する(所要時間は目安6〜10分、225銘柄×2つの外部APIを呼ぶため)。
- 生成したJSONを管理画面(`/admin/stock_screening_runs`)からアップロードすると、
  `StockScreeningRun`として1レコード保存される。アップロードごとに新しいレコードが
  作られるため、過去の分析結果もすべて履歴として閲覧できる。
- `show`画面では候補・除外(バリュートラップ疑い)の一覧テーブルに加え、アップロードした
  JSON全体を折りたたみ表示で確認できる(`StockScreeningRun#result_data`にそのまま保存)。

## 現在価格の更新(詳細画面)

`show`画面の「現在価格を更新」ボタンを押すと、その回の結果に表示されている銘柄
(候補・除外リストの両方)について`YahooFinanceClient`(`app/services/yahoo_finance_client.rb`、
直近日足の終値を1件だけ取得する軽量版)で現在価格を取得し、アップロード時点の価格
(`price`、JSON取り込み時に保存)からの変動率を`result_data`に書き込んで保存する
(`StockScreeningRun#refresh_prices!`)。この処理だけは唯一、Rails側(本番含む)から
直接外部APIを呼ぶ箇所になるが、1回あたり表示銘柄数十件程度の軽い呼び出しのみで、
全銘柄の履歴取得(ローカルスクリプト側の仕事)とは規模が全く異なるためWebリクエスト内で
同期的に処理している。

**常に最新の現在価格との比較になる**(「前回確認した価格」との差分ではなく、毎回
アップロード時点の`price`からの変動率を計算し直して上書きする)。`price`フィールドが
無い旧形式のJSON(本機能追加前にアップロードしたもの)は、該当銘柄の更新がスキップされ
「未確認」と表示される。

## 売り時の目安(候補テーブルの赤背景)

各銘柄の`sell_threshold_price`(`find_undervalued_stocks.rb`が算出、自分史内のPBR位置が
選定基準(下位40%)を超える株価=「もう割安ではなくなる」目安)と、現在価格(現在価格更新済み
なら`latest_price`、未更新なら`price`)を比較し、現在価格が`sell_threshold_price`以上になった
候補行を赤背景(`table-danger`)+「売り時」バッジで表示する(`StockScreeningRun.sell_time?`)。
除外(バリュートラップ疑い)リストにはこの判定は適用しない(そもそも買い候補ではないため)。
`sell_threshold_price`が無い旧形式のJSONは判定自体が行われない(常にfalse)。

## なぜRender上でAPIを直接叩かない設計にしたか

225銘柄×(Yahoo Finance価格取得+J-Quantsファンダメンタルズ取得、バックオフ付き)は
6〜10分かかる。実行頻度も3ヶ月に1回程度の想定で、Webリクエスト内や本番のバックグラウンド
ジョブとして持たせる必要性が薄い一方、本番(Render)にJ-QuantsのAPIキーや長時間実行の
仕組みを持たせるコストの方が大きいと判断し、「ローカルで生成したJSONをアップロードする」
方式にした。

## 必要な環境変数

| 変数 | 用途 | 設定場所 |
|---|---|---|
| `JQUANTS_API_KEY` | J-Quants APIの認証 | `finance/stocks`リポジトリの`.env`のみ。**real_word_rpg(Rails/Render)側には一切不要** |

## 既知の注意点

- アップロードされたJSONの形式は`find_undervalued_stocks.rb`の出力(`generated_at`・
  `universe_size`・`analyzed_count`・`skipped_codes`・`candidates`・`excluded_value_traps`)
  を前提にしている。手で加工したJSONをアップロードする場合は同じキー構成にすること。
- このスクリーニングは「さらに深く調べる価値がある候補の絞り込み」であり、投資の
  最終判断材料ではない(`finance/stocks/README.md`参照。個別銘柄の観測数は10〜20四半期程度と
  少なく、統計的に有意な候補はごく一部)。
