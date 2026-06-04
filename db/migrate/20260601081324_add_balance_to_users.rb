class AddBalanceToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :balance, :integer, null: false, default: 0
  end
end
