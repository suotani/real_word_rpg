# 4戦略(NyRolloverDip/NyRolloverRebound/GotoBiFixing/DipBounce)で共有する
# 時刻判定・損切り判定ヘルパー。検証結果・根拠は fx/README.md (別リポジトリの
# バックテスト環境)を参照。
module FxStrategies
  module_function

  def time_at_or_after?(now, hour, min)
    now.hour > hour || (now.hour == hour && now.min >= min)
  end

  # [h1:m1, h2:m2) の半開区間に now が入っているか(日またぎは想定しない)
  def in_window?(now, h1, m1, h2, m2)
    time_at_or_after?(now, h1, m1) && !time_at_or_after?(now, h2, m2)
  end

  # side(BUY/SELL)から見た不利方向への逆行が stop_loss_yen に達したか。
  # SELLは価格上昇、BUYは価格下落が不利方向(FxTradeBatchService#check_fixed_time_exitで使う。
  # ①②はSELL、④はBUYのため、固定時刻決済の戦略全体で方向を意識する必要がある)。
  def stop_loss_hit?(side, entry_price, current_price, stop_loss_yen)
    if side == 'SELL'
      current_price >= entry_price + stop_loss_yen
    else
      current_price <= entry_price - stop_loss_yen
    end
  end
end
