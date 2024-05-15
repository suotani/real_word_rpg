class AddColumnCharactorIdToTicket < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :charactor_id, :integer
    remove_column :tickets, :user_id
  end
end
