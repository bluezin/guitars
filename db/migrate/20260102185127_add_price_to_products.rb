class AddPriceToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :price, :decimal
  end
end
