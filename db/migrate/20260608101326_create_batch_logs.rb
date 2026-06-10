class CreateBatchLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :batch_logs do |t|
      t.date    :target_date,     null: false
      t.integer :hour,            null: false  # 0-23: 時間帯バッチ / -1: 日次サマリー
      t.integer :purchased_count, null: false, default: 0
      t.integer :total_amount,    null: false, default: 0

      t.timestamps
    end

    add_index :batch_logs, [:target_date, :hour]
  end
end
