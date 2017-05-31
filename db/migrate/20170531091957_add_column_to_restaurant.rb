class AddColumnToRestaurant < ActiveRecord::Migration[5.0]
  def change
    add_column :restaurants, :cook_rank, :float
    add_column :restaurants, :value_balance, :float
  end
end
