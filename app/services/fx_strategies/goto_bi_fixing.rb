# ②ゴトー日仲値アノマリー。
# 暦日が5,10,15,20,25,30日、または月末営業日(ゴトー日)の時だけ、東京仲値決定時刻
# (JST9:55)にショート→10:05に決済。①と時間帯が重ならないため両建てリスクはない。
# 学習221トレード・勝率52.9%/検証67トレード・勝率41.8%(①より頑健性は低い)。
module FxStrategies
  module GotoBiFixing
    KEY = 'goto_bi_fixing'
    ENTRY_SIDE = 'SELL'
    ENTRY_HOUR = 9
    ENTRY_MIN = 55
    EXIT_HOUR = 10
    EXIT_MIN = 5

    module_function

    def entry_signal?(now)
      goto_bi_day?(now.to_date) && now.hour == ENTRY_HOUR && now.min == ENTRY_MIN
    end

    def time_exit?(now)
      FxStrategies.time_at_or_after?(now, EXIT_HOUR, EXIT_MIN)
    end

    def goto_bi_day?(date)
      [5, 10, 15, 20, 25, 30].include?(date.day) || last_business_day_of_month?(date)
    end

    def last_business_day_of_month?(date)
      return false unless weekday?(date)

      d = date.end_of_month.to_date
      d -= 1 until weekday?(d)
      d == date
    end

    def weekday?(date)
      (1..5).cover?(date.wday)
    end
  end
end
