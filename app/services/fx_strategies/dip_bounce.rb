# ③ディップ・バウンス(優先度最低)。
# 暦日の始値から0.05円以上下げた最初の時点(1日1回だけ、5分足判定)でロング→
# 120分タイムアウト、または始値から0.3円逆行でストップロス。
# 学習915トレード・勝率54.1%/検証281トレード・勝率50.9%。
#
# 「USD/JPYの上昇トレンドに乗っているだけ(トレンドフォロー)では」という懸念を、
# fxリポジトリのbacktests/regime_filtered_portfolio_backtest.rbで検証した結果、
# 検証期間のdownレジーム(1時間足SMA50<SMA200)で平均損益が-32.3円の負に転落し確定した。
# さらに追加検証(discover_indicator_filters.rb)で、RSI(14、1時間足)>=50の方がこの
# トレンドレジームより明確に強く、かつ独立した情報を持つ(down×RSI>=50でも儲かる)と
# 確認できたため、現在はRSIベースのフィルター値(FxTrendRegimeService参照。'up'/'down'
# という名前は旧トレンド判定時代の名残で、実体はRSI(14)>=50か否か)が'up'の時だけ
# エントリーする(詳細はfx/README.md「検証メモ」の「レジーム・指標フィルター」節を参照)。
#
# GMOコインは同一銘柄での両建て(反対方向の同時保有)ができない前提のため、
# ①②④(他の3戦略)の稼働時間帯には新規エントリーしない。保有中にその時間帯へ
# 入った場合は、優先度の高い戦略に明け渡すため強制決済する(forced_handoff?)。
# ④NyRolloverReboundはDipBounceと同じBUY方向だが、GMOは同一銘柄の建玉を戦略単位では
# 分けて管理できず、このアプリ側でも「建玉なし」を前提にエントリーする作りのため、
# 同方向であっても同時保有は避ける。
module FxStrategies
  module DipBounce
    KEY = 'dip_bounce'
    ENTRY_SIDE = 'BUY'
    ENTRY_DIP_YEN = 0.05
    TIMEOUT_MINUTES = 120
    REQUIRED_SIGNAL = 'up' # FxTrendRegimeService参照。実体はRSI(14,1時間足)>=50

    BLOCKED_WINDOWS = [
      [NyRolloverDip::ENTRY_HOUR, NyRolloverDip::ENTRY_MIN, NyRolloverDip::EXIT_HOUR, NyRolloverDip::EXIT_MIN],
      [NyRolloverRebound::ENTRY_HOUR, NyRolloverRebound::ENTRY_MIN, NyRolloverRebound::EXIT_HOUR, NyRolloverRebound::EXIT_MIN],
      [GotoBiFixing::ENTRY_HOUR, GotoBiFixing::ENTRY_MIN, GotoBiFixing::EXIT_HOUR, GotoBiFixing::EXIT_MIN]
    ].freeze

    module_function

    # signal: FxTrendRegimeService.currentの戻り値('up'/'down'/nil)をそのまま渡す。
    # nil(フィルター値未取得・取得失敗)の場合は安全側に倒してエントリーしない。
    def entry_signal?(now, day_open, current_price, signal)
      signal == REQUIRED_SIGNAL && five_minute_bar?(now) && !blocked_time?(now) &&
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
