class AddCodeToRestaurant < ActiveRecord::Migration[7.2]
  def change
    add_column :restaurants, :code, :string, null: false
  end
end
