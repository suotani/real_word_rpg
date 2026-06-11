class CreateSalesLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :sales_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.date    :target_date,   null: false
      t.integer :sales_count,   null: false, default: 0
      t.integer :sales_amount,  null: false, default: 0

      t.timestamps
    end

    add_index :sales_logs, [:user_id, :target_date], unique: true
  end
end
