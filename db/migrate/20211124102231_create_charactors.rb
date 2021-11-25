class CreateCharactors < ActiveRecord::Migration[5.2]
  def change
    create_table :charactors do |t|
      t.string :name
      t.integer :user_id
      t.integer :exp, default: 0
      t.integer :motion_level, default: 1
      t.integer :knowledge_level, default: 1
      t.integer :health_level, default: 1
      t.integer :communication_level, default: 1

      t.timestamps
    end
  end
end
