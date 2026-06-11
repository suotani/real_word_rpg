class AddCostAmountToSalesLogs < ActiveRecord::Migration[7.2]
  def change
    add_column :sales_logs, :cost_amount, :integer, null: false, default: 0
  end
end
