class AddColumnCharactorIdToTicket < ActiveRecord::Migration[5.2]
  def change
    c = Charactor.take
    add_column :tickets, :charactor_id, :integer, default: c.id
    remove_column :tickets, :user_id
  end
end
