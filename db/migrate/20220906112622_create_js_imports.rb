class CreateJsImports < ActiveRecord::Migration[5.2]
  def change
    create_table :js_imports do |t|
      t.integer  "managed_html_id"
      t.integer  "managed_js_id"
      t.timestamps
    end
  end
end
