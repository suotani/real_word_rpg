class CreateExperiences < ActiveRecord::Migration[5.2]
  def change
    create_table :experiences do |t|
      t.string :name
      t.string :unit
      t.integer :unit_exp
      t.integer :level, default: 1
      t.integer :exp, default: 0
      t.string :explanation
      t.integer :charactor_id
      t.integer :category_id

      t.timestamps
    end
  end
end
