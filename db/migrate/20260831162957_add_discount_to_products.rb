class AddDiscountToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :discount_percent, :integer, default: nil
  end
end
