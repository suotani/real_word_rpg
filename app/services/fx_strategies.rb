# 3戦略(NyRolloverDip/GotoBiFixing/DipBounce)で共有する時刻判定ヘルパー。
# 検証結果・根拠は fx/README.md (別リポジトリのバックテスト環境)を参照。
module FxStrategies
  module_function

  def time_at_or_after?(now, hour, min)
    now.hour > hour || (now.hour == hour && now.min >= min)
  end

  # [h1:m1, h2:m2) の半開区間に now が入っているか(日またぎは想定しない)
  def in_window?(now, h1, m1, h2, m2)
    time_at_or_after?(now, h1, m1) && !time_at_or_after?(now, h2, m2)
  end
end
