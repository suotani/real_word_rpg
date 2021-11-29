class AddColumnCategoryExpToCharactor < ActiveRecord::Migration[5.2]
  def change
    add_column :charactors, :motion_exp, :integer, default: 0
    add_column :charactors, :knowledge_exp, :integer, default: 0
    add_column :charactors, :health_exp, :integer, default: 0
    add_column :charactors, :communication_exp, :integer, default: 0
  end
end
