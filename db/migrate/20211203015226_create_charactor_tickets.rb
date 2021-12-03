class CreateCharactorTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :charactor_tickets do |t|
      t.integer :ticket_id
      t.integer :charactor_id
      t.boolean :used, default: false

      t.timestamps
    end
  end
end
