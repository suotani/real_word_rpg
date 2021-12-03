class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.integer :user_id
      t.string :title
      t.string :color

      t.timestamps
    end
  end
end
