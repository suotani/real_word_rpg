# FX戦略ごとの実行パラメータ(戦略につき1行)。
# admin画面(/admin/resources/fx_bot_setting)から値を編集できる。
# enabled を false にするとその戦略だけ FxTradeBatchService が即座に何もせず終了する
# (「cronを止める」のではなく、cronは動いたままアプリ側で無効化するキルスイッチ)。
# エントリー/決済時刻は戦略ごとに固定のため、ここでは持たない
# (app/services/fx_strategies/ 配下のコードを参照)。
class FxBotSetting < ApplicationRecord
  STRATEGIES = %w[ny_rollover_dip ny_rollover_rebound goto_bi_fixing dip_bounce].freeze

  validates :strategy, presence: true, inclusion: { in: STRATEGIES }, uniqueness: true
  validates :size, numericality: { greater_than: 0 }
  validates :stop_loss_yen, numericality: { greater_than: 0 }

  def self.for(strategy)
    find_by!(strategy: strategy)
  end
end
