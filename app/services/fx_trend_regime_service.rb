# 1時間足SMA50/SMA200のトレンドレジーム('up'/'down')を判定し、FxMarketRegimeにキャッシュする。
#
# fxリポジトリ(バックテスト環境)で、DipBounceTrader(③ディップ・バウンス)の「下落後ロング」が
# USD/JPYの2020-2025年の上昇トレンドに乗っているだけではないかという懸念を
# backtests/regime_filtered_portfolio_backtest.rb で検証した結果:
#   - 検証期間(2024-2025)でdownレジームの平均損益が-32.3円(合計-3,520円)の負に転落し、
#     疑いが確定した。upレジームのみに絞ると学習・検証の両方で勝率・平均損益/トレード・
#     最大ドローダウンが改善した(詳細は fx/README.md「検証メモ」のレジームフィルター節を参照)。
# これをFxStrategies::DipBounceのエントリー条件に適用する。
#
# 1時間足basisの判定なので毎分再計算する必要はなく、FxMarketRegimeに最後の計算結果を
# キャッシュして一定時間(max_age)だけ再利用する(klines取得にdays回のHTTPリクエストが
# かかるため、cronの毎分呼び出しで毎回叩くのは無駄が大きい)。
module FxTrendRegimeService
  FAST_SMA = 50
  SLOW_SMA = 200
  LOOKBACK_DAYS = 10 # SMA200(約8.3日分)に土日・祝日の欠損を見込んで余裕を持たせる
  DEFAULT_MAX_AGE = 55.minutes

  module_function

  # キャッシュ(FxMarketRegime)が古ければ再計算して保存し、現在のトレンドレジームを返す。
  # 取得失敗時(API障害等)は、再計算できなければ前回値を返す(過去に一度も計算できていない
  # 場合のみnil)。
  def current(max_age: DEFAULT_MAX_AGE)
    latest = FxMarketRegime.latest
    return latest.trend if latest && latest.computed_at >= max_age.ago

    trend = compute
    return latest&.trend if trend.nil?

    FxMarketRegime.create!(trend:, computed_at: Time.current)
    trend
  end

  # 直近LOOKBACK_DAYS日分の1時間足終値からSMA50/SMA200を計算し、'up'(SMA50>=SMA200)/'down'を
  # 返す(本数不足・取得失敗時はnil)
  def compute
    closes = GmoCoinApi.get_hourly_closes(days: LOOKBACK_DAYS)
    return nil if closes.size < SLOW_SMA

    fast = closes.last(FAST_SMA).sum / FAST_SMA.to_f
    slow = closes.last(SLOW_SMA).sum / SLOW_SMA.to_f
    fast >= slow ? 'up' : 'down'
  end
end

