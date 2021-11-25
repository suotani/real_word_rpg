class CreateExperienceLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :experience_logs do |t|
      t.integer :experience_id
      t.integer :unit
      t.string :comment

      t.timestamps
    end
  end
end
