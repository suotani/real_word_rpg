# FXトレードボット(NYロールオーバー・ディップ)

GMOコインAPIを使い、USD/JPYを毎日決まった時刻にショート→決済する自動売買バッチ。
**実際の口座・実際の資金で発注する**ため、他のバッチ(仮想顧客購入・バイト等)とは
リスクの性質が異なる点に注意すること。

ロジックの根拠・検証結果は別リポジトリ `fx`(バックテスト環境)で統計的に確認したもの。
詳細は `fx/README.md` の「検証メモ: NYロールオーバー・ディップ」を参照。

## 仕組み

- `FxBotSetting`(シングルトン、`/admin/resources/fx_bot_setting`で編集): `enabled`・`size`(発注サイズ)・
  `stop_loss_yen`・`entry_hour`/`entry_min`・`exit_hour`/`exit_min`
- `FxTradeLog`(`/admin/resources/fx_trade_log`で閲覧): 発注・決済・損切り・エラーの記録
- `GmoCoinApi`(`app/services/gmo_coin_api.rb`): GMOコインFX APIラッパー
- `FxTradeBatchService`(`app/services/fx_trade_batch_service.rb`): 1回呼ばれるごとに
  現在時刻・建玉状況を見て「何もしない/エントリー/決済」を1つだけ判断するワンショット処理
- `POST /api/batches/fx_trade`(`BATCH_SECRET_TOKEN`認証): Renderのcronサービス
  `fx-trade-batch`(`render.yaml`、毎分実行)から叩かれる

## 必要な環境変数

| 変数 | 用途 | 設定場所 |
|---|---|---|
| `GMO_API_KEY` / `GMO_API_SECRET` | GMOコインAPI認証 | Web側のみ(Renderダッシュボード、またはローカルは`.env`) |
| `BATCH_SECRET_TOKEN` | cron→API間の認証(既存の仕組みを流用) | cron・Web両方 |

## 止め方(キルスイッチ)

`FxBotSetting.enabled` を `false` にすると、cron自体は動き続けるが`FxTradeBatchService`が
即座に`{skipped: true, reason: 'disabled'}`を返して何もしない。緊急停止はまずここ。
**デフォルトは`enabled: false`**(マイグレーション直後は何も取引しない)。

## 重要な注意点(実装時点で未検証)

- **時刻の前提が未検証**: エントリー06:50 JST・決済07:05 JSTという時刻は、過去にダウンロードした
  ヒストリカルCSV(サーバー時間固定UTC+2、発行元不明)での発見をJSTに変換したもの。GMOコイン自身の
  実際の値動きが同じ時間帯で同じパターンを示すかどうかは、実際に動かして確認する必要がある。
- **スワップ(ロールオーバー)費用は未考慮**: このバッチが建玉を持つのはまさに一般的なスワップ計算
  タイミング付近。バックテストはスプレッドのみを織り込んでおり、実際の損益はスワップ分だけ
  悪化する可能性がある。
- **実測スプレッドはバックテスト想定より大きかった**: `fx`リポジトリでの実発注テスト(100通貨)では、
  往復スプレッドがバックテスト想定(0.3pips相当)の3倍前後(約0.9〜1.1pips)だった。
- **最小発注サイズはAPI上100通貨**(`GET /public/v1/symbols`の`minOpenOrderSize`で確認可能)。
  サイズを上げる前に、口座残高に対する必要証拠金(目安: 想定レート×サイズ×4%)を確認すること。
