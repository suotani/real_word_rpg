# ①NYロールオーバー・ディップ(最優先戦略)。
# サーバー時間23:50に無条件ショート→0:05に決済。サーバー時間固定UTC+2で記録された
# ヒストリカルデータでの発見をJSTに変換した時刻(06:50/07:05)を使う。
# 学習1,015トレード・勝率71.9%/検証300トレード・勝率84.3%(t=-6.10/-6.32で強く有意)。
module FxStrategies
  module NyRolloverDip
    KEY = 'ny_rollover_dip'
    ENTRY_SIDE = 'SELL'
    ENTRY_HOUR = 6
    ENTRY_MIN = 50
    EXIT_HOUR = 7
    EXIT_MIN = 5

    module_function

    def entry_signal?(now)
      now.hour == ENTRY_HOUR && now.min == ENTRY_MIN
    end

    def time_exit?(now)
      FxStrategies.time_at_or_after?(now, EXIT_HOUR, EXIT_MIN)
    end
  end
end
