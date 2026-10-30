# DipBounceのエントリーフィルター値('up'=favorable/'down'=unfavorable)を判定し、
# FxMarketRegimeにキャッシュする。
#
# 【2026-10-30更新】当初は1時間足SMA50/SMA200のトレンドクロスで判定していたが、
# fxリポジトリでの追加検証(discover_indicator_filters.rb、backtests/regime_filtered_
# portfolio_backtest.rb)で、RSI(14、1時間足)>=50の方がトレンドレジームより明確に強く、
# かつ独立した情報を持つ(down×RSI>=50でも儲かる=トレンドの劣化版ではない)ことが
# train/testの両方で確認されたため、判定ロジックをRSIベースに置き換えた
# (詳細はfx/README.md「検証メモ」の「レジーム・指標フィルター」節を参照)。
# 'up'/'down'という値名は旧トレンド判定時代の名残だが、キャッシュ機構(FxMarketRegime)
# ・呼び出し側(FxStrategies::DipBounce)を変えずに済むようそのまま流用している。
# 'up' = RSI(14)>=50(favorable、エントリー可)、'down' = RSI(14)<50(unfavorable、見送り)。
#
# 1時間足basisの判定なので毎分再計算する必要はなく、FxMarketRegimeに最後の計算結果を
# キャッシュして一定時間(max_age)だけ再利用する(klines取得にdays回のHTTPリクエストが
# かかるため、cronの毎分呼び出しで毎回叩くのは無駄が大きい)。
module FxTrendRegimeService
  RSI_PERIOD = 14
  RSI_FAVORABLE_THRESHOLD = 50
  LOOKBACK_DAYS = 10 # RSI(14)には15本で足りるが、土日・祝日の欠損を見込んで余裕を持たせる
  DEFAULT_MAX_AGE = 55.minutes

  module_function

  # キャッシュ(FxMarketRegime)が古ければ再計算して保存し、現在のフィルター値を返す。
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

  # 直近LOOKBACK_DAYS日分の1時間足終値からRSI(14)を計算し、'up'(RSI>=50)/'down'(RSI<50)を
  # 返す(本数不足・取得失敗時はnil)
  def compute
    closes = GmoCoinApi.get_hourly_closes(days: LOOKBACK_DAYS)
    return nil if closes.size < RSI_PERIOD + 1

    rsi_value = rsi(closes, RSI_PERIOD)
    rsi_value >= RSI_FAVORABLE_THRESHOLD ? 'up' : 'down'
  end

  # RSI(相対力指数)。fx/modules/technical.rbの実装(Wilderの平滑化なし、単純平均版)と
  # 揃えてある(discover_indicator_filters.rbで検証した計算式と一致させるため)。
  def rsi(closes, period)
    gains = []
    losses = []
    (1..period).each do |i|
      change = closes[-i] - closes[-i - 1]
      change >= 0 ? gains << change : losses << -change
    end

    avg_gain = gains.sum / period.to_f
    avg_loss = losses.sum / period.to_f
    rs = avg_gain / (avg_loss.nonzero? || 1e-10)
    100 - (100 / (1 + rs))
  end
end

