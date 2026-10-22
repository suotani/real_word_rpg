# FXロールオーバー・ディップ戦略の実行パラメータ(常に1行だけ使うシングルトン)。
# admin画面(/admin/resources/fx_bot_setting)から値を編集できる。
# enabled を false にすると FxTradeBatchService が即座に何もせず終了する
# (「cronを止める」のではなく、cronは動いたままアプリ側で無効化するキルスイッチ)。
class FxBotSetting < ApplicationRecord
  validates :size, numericality: { greater_than: 0 }
  validates :stop_loss_yen, numericality: { greater_than: 0 }
  validates :entry_hour, :exit_hour, inclusion: 0..23
  validates :entry_min, :exit_min, inclusion: 0..59

  def self.instance
    first_or_create!
  end
end
