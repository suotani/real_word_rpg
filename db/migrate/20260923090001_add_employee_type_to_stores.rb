class AddEmployeeTypeToStores < ActiveRecord::Migration[7.2]
  def change
    add_reference :stores, :employee_type, null: true, foreign_key: true
  end
end
