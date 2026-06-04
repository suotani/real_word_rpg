# frozen_string_literal: true

class ChangeMaterialsAmountNull < ActiveRecord::Migration[7.2]
  def change
    change_column_null :materials, :amount, true
  end
end
