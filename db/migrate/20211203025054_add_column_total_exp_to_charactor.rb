class AddColumnTotalExpToCharactor < ActiveRecord::Migration[5.2]
  def change
    add_column :charactors, :total_exp, :integer, default: 0
  end
end
