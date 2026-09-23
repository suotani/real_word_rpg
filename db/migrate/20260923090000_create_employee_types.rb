class CreateEmployeeTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :employee_types do |t|
      t.string  :name, null: false
      t.integer :hire_cost, null: false, default: 0
      t.float   :attractiveness_bonus, null: false, default: 0.0
      t.float   :purchase_discount_rate, null: false, default: 0.0
      t.integer :extra_customer_count, null: false, default: 0
      t.float   :bonus_customer_balance_multiplier, null: false, default: 1.0
      t.float   :virtual_sale_bonus_rate, null: false, default: 0.0
      t.text    :description

      t.timestamps
    end

    add_index :employee_types, :name, unique: true
  end
end
