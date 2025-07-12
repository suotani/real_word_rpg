class AddColumnTownIdToUser < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :town, null: true, foreign_key: true, comment: "現在の街"
  end
end
