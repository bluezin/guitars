class OrderItemsController < ApplicationController
  allow_unauthenticated_access only: %i[destroy]

  def destroy
    item = OrderItem.find(params[:id])

    if item.quantity <= 1
      item.destroy
      notice = "Producto eliminado del carrito"
    else
      item.decrement!(:quantity)
      notice = "Cantidad actualizada"
    end

    redirect_back fallback_location: products_path, notice: notice
  end
end
