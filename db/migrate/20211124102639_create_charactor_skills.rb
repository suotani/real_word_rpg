class CreateCharactorSkills < ActiveRecord::Migration[5.2]
  def change
    create_table :charactor_skills do |t|
      t.integer :skill_id
      t.integer :charactor_id
      t.integer :level, default: 1

      t.timestamps
    end
  end
end
