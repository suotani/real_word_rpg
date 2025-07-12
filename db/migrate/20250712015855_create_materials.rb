class CreateMaterials < ActiveRecord::Migration[7.2]
  def change
    create_table :materials do |t|
      t.references :item, null: false, foreign_key: true
      t.integer :amount, null: false
      t.timestamps
    end
  end
end
