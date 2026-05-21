class CreateRecipes < ActiveRecord::Migration[7.2]
  def change
    create_table :recipes do |t|
      t.references :store, null: false, foreign_key: true
      t.string :name, null: false
      t.timestamps
    end
  end
end
