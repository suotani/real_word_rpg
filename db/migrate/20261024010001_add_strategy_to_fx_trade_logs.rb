# 複数戦略を同時に動かすため、各ログ行がどの戦略のものかを記録する。
# 二重発注防止の一意制約も (trade_date, event) から (trade_date, strategy, event) に
# 変更する(戦略ごとに独立して「1日1回」を守らせる)。daily_openは戦略dip_bounceが
# 当日の始値を記録・再利用するためのイベント。
class AddStrategyToFxTradeLogs < ActiveRecord::Migration[7.2]
  def up
    add_column :fx_trade_logs, :strategy, :string
    FxTradeLog.reset_column_information
    FxTradeLog.update_all(strategy: 'ny_rollover_dip')
    change_column_null :fx_trade_logs, :strategy, false

    remove_index :fx_trade_logs, name: 'idx_fx_trade_logs_claim'
    add_index :fx_trade_logs, %i[trade_date strategy event],
              unique: true,
              where: "event IN ('entry','close','daily_open')",
              name: 'idx_fx_trade_logs_claim'
  end

  def down
    remove_index :fx_trade_logs, name: 'idx_fx_trade_logs_claim'
    add_index :fx_trade_logs, %i[trade_date event],
              unique: true,
              where: "event IN ('entry','close')",
              name: 'idx_fx_trade_logs_claim'
    remove_column :fx_trade_logs, :strategy
  end
end
