class CreateManagedJs < ActiveRecord::Migration[5.2]
  def change
    create_table :managed_js do |t|
      t.integer  "managed_html_id", null: false
      t.text     "body"
      t.timestamps
    end
  end
end
