class AllowNullUserInStoresAndStocks < ActiveRecord::Migration[7.2]
  def change
    change_column_null :stores, :user_id, true
    change_column_null :stocks, :user_id, true
  end
end
