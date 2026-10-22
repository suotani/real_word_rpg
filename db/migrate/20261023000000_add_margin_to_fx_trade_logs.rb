class AddMarginToFxTradeLogs < ActiveRecord::Migration[7.2]
  def change
    # 決済時点でのFX取引余力(GMOコインAPIの availableAmount)を記録する
    add_column :fx_trade_logs, :margin, :decimal, precision: 14, scale: 3
  end
end
