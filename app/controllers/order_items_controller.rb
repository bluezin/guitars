class OrderItemsController < ApplicationController
  allow_unauthenticated_access only: %i[destroy]

  def destroy
    item = OrderItem.find(params[:id])

    if item.quantity <= 1
      item.destroy
      notice = t("orderItems.productRemoved")
    else
      item.decrement!(:quantity)
      notice = t("orderItems.updatedAmount")
    end

    product = Product.find_by(id: item.product_id)

    product.inventory_count = product.inventory_count + 1
    product.save

    redirect_back fallback_location: products_path, notice: notice
  end
end
