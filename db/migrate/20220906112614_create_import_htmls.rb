class CreateImportHtmls < ActiveRecord::Migration[5.2]
  def change
    create_table :import_htmls do |t|
      t.integer  "managed_html_id"
      t.integer  "import_html_id"
      t.integer "asset_type"
      t.timestamps
    end
  end
end
