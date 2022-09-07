class CreateManagedHtmls < ActiveRecord::Migration[5.2]
  def change
    create_table :managed_htmls do |t|
      t.string   "title"
      t.integer  "user_id"
      t.boolean  "public",                    null: false,   default: false
      t.text     "body"
      t.text     "js_body"
      t.text     "css_body"
      t.string   "note"
      t.text     "yaml"
      t.boolean  "use_yaml",   default: true
      t.integer  "level"
      t.string   "js_note"
      t.string   "css_note"
      t.string   "address"
      t.timestamps
    end
  end
end
