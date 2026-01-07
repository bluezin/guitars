class OrdersController < ApplicationController
  allow_unauthenticated_access only: %i[add_product]

  def add_product
    product = Product.find(params[:product_id])

    item = @order.order_items.find_or_initialize_by(product: product)
    item.quantity ||=0
    item.quantity += 1
    item.price = product.price
    item.save

    redirect_to products_path, notice: "Producto agregado al carrito"
  end

  def show
  end
end
