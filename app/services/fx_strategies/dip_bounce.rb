# ③ディップ・バウンス(優先度最低)。
# 暦日の始値から0.05円以上下げた最初の時点(1日1回だけ、5分足判定)でロング→
# 120分タイムアウト、または始値から0.3円逆行でストップロス。
# 学習915トレード・勝率54.1%/検証281トレード・勝率50.9%。
#
# 「USD/JPYの上昇トレンドに乗っているだけ(トレンドフォロー)では」という懸念を、
# fxリポジトリのbacktests/regime_filtered_portfolio_backtest.rbで検証した結果、
# 検証期間のdownレジーム(1時間足SMA50<SMA200)で平均損益が-32.3円の負に転落し確定した
# (詳細はfx/README.md「検証メモ」のレジームフィルター節を参照)。そのため、
# トレンドレジームが'up'(SMA50>=SMA200)の時だけエントリーする(FxTrendRegimeService参照)。
#
# GMOコインは同一銘柄での両建て(反対方向の同時保有)ができない前提のため、
# ①②(ショート)の稼働時間帯には新規エントリーしない。保有中に①②の時間帯へ
# 入った場合は、優先度の高い戦略に明け渡すため強制決済する(forced_handoff?)。
module FxStrategies
  module DipBounce
    KEY = 'dip_bounce'
    ENTRY_SIDE = 'BUY'
    ENTRY_DIP_YEN = 0.05
    TIMEOUT_MINUTES = 120
    REQUIRED_TREND = 'up'

    BLOCKED_WINDOWS = [
      [NyRolloverDip::ENTRY_HOUR, NyRolloverDip::ENTRY_MIN, NyRolloverDip::EXIT_HOUR, NyRolloverDip::EXIT_MIN],
      [GotoBiFixing::ENTRY_HOUR, GotoBiFixing::ENTRY_MIN, GotoBiFixing::EXIT_HOUR, GotoBiFixing::EXIT_MIN]
    ].freeze

    module_function

    # trend: FxTrendRegimeService.currentの戻り値('up'/'down'/nil)をそのまま渡す。
    # nil(レジーム未取得・取得失敗)の場合は安全側に倒してエントリーしない。
    def entry_signal?(now, day_open, current_price, trend)
      trend == REQUIRED_TREND && five_minute_bar?(now) && !blocked_time?(now) &&
        current_price <= day_open - ENTRY_DIP_YEN
    end

    def stop_loss_hit?(day_open, current_price, stop_loss_yen)
      current_price <= day_open - stop_loss_yen
    end

    def timeout?(now, entered_at)
      now >= entered_at + TIMEOUT_MINUTES.minutes
    end

    def forced_handoff?(now)
      blocked_time?(now)
    end

    def five_minute_bar?(now)
      (now.min % 5).zero?
    end

    def blocked_time?(now)
      BLOCKED_WINDOWS.any? { |h1, m1, h2, m2| FxStrategies.in_window?(now, h1, m1, h2, m2) }
    end
  end
end
