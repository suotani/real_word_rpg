class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string  "name"
      t.integer "taggings_count", default: 0
    end
  end
end
