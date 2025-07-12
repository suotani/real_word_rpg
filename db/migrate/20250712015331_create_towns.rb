class CreateTowns < ActiveRecord::Migration[7.2]
  def change
    create_table :towns do |t|
      t.string :name, null: false
      t.integer :user_id, null: false, comment: "町長"
      t.timestamps
    end
  end
end
