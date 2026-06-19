class AllowNullTownIdOnStores < ActiveRecord::Migration[7.2]
  def change
    change_column_null :stores, :town_id, true
  end
end
