class DropSkillsTable < ActiveRecord::Migration[7.2]
  def change
    drop_table :skills do |t|
      t.bigint :id, null: false, auto_increment: true
      t.string :name
      t.text :explanation
      t.integer :category_id
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
    drop_table :charactor_skills do |t|
      t.bigint :id, null: false, auto_increment: true
      t.bigint :charactor_id
      t.bigint :skill_id
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
    drop_table :experience_logs do |t|
      t.bigint :id, null: false, auto_increment: true
      t.bigint :experience_id
      t.bigint :charactor_id
      t.integer :level
      t.integer :exp
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end
end
