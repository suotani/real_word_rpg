class AddRecipeIdToMaterials < ActiveRecord::Migration[7.2]
  def change
    add_reference :materials, :recipe, null: true, foreign_key: { to_table: :items }
  end
end
