# ④NYロールオーバー・リバウンド(①の決済直後に続ける反発狙い)。
# ①NyRolloverDip(SELL、06:50→07:05)の決済直後(07:05)にBUYでエントリーし、08:00に決済する。
# ①が捉える急落の直後に続く反発局面を狙う戦略で、fxリポジトリ(バックテスト環境)で
# 学習966トレード・勝率64.1%(t=+9.99)/検証294トレード・勝率51.0%(t=+3.62)と検証済み
# (詳細はfx/README.md「検証メモ」のNYロールオーバー・リバウンド節を参照)。
#
# ①の決済時刻にそのままエントリーするため時間帯は重ならず、両建てにはならない。
module FxStrategies
  module NyRolloverRebound
    KEY = 'ny_rollover_rebound'
    ENTRY_SIDE = 'BUY'
    ENTRY_HOUR = 7
    ENTRY_MIN = 5
    EXIT_HOUR = 8
    EXIT_MIN = 0

    module_function

    def entry_signal?(now)
      now.hour == ENTRY_HOUR && now.min == ENTRY_MIN
    end

    def time_exit?(now)
      FxStrategies.time_at_or_after?(now, EXIT_HOUR, EXIT_MIN)
    end
  end
end
