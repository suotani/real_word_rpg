class CreateCssImports < ActiveRecord::Migration[5.2]
  def change
    create_table :css_imports do |t|
      t.integer  "managed_html_id"
      t.integer  "managed_css_id"
      t.timestamps
    end
  end
end
