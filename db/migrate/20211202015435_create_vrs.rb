class CreateVrs < ActiveRecord::Migration[5.2]
  def change
    create_table :vrs do |t|
      t.integer :user_id
      t.string :title
      t.timestamps
    end
  end
end
