class AddActiveToBaitos < ActiveRecord::Migration[7.2]
  def change
    add_column :baitos, :active, :boolean, null: false, default: true
  end
end
