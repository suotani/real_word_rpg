class CreateStockScreeningRuns < ActiveRecord::Migration[7.2]
  def change
    create_table :stock_screening_runs do |t|
      t.datetime :generated_at, null: false
      t.integer :candidate_count, null: false, default: 0
      t.string :source_filename
      t.json :result_data, null: false

      t.timestamps
    end
  end
end
