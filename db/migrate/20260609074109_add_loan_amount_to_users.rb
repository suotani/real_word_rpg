class AddLoanAmountToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :loan_amount, :integer, null: false, default: 0
  end
end
