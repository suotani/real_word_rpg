class CreateUserTowns < ActiveRecord::Migration[7.2]
  def change
    create_table :user_towns do |t|
      t.references :user, null: false, foreign_key: true
      t.references :town, null: false, foreign_key: true
      t.timestamps
    end
  end
end
