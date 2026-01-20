class AddFieldsToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :mp_payment_id, :string
    add_column :orders, :paid_at, :datetime
  end
end
