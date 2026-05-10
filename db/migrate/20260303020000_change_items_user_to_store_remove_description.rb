# frozen_string_literal: true

class ChangeItemsUserToStoreRemoveDescription < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :items, :users, if_exists: true
    remove_index :items, :user_id, if_exists: true
    remove_column :items, :user_id, null: false

    add_reference :items, :store, null: true, foreign_key: true

    remove_column :items, :description, null: false
  end
end
