class OrdersController < ApplicationController
  allow_unauthenticated_access only: %i[add_product checkout success]
  protect_from_forgery width: :null_session, only: :success

  def add_product
    convert_number =params["addToCart"].to_i
    final_number = convert_number === 0 ? 1 : convert_number
    product = Product.find(params[:product_id])
    product.inventory_count -= final_number
    product.save

    item = @order.order_items.find_or_initialize_by(product: product)

    item.quantity ||=0
    item.quantity += final_number
    item.price = product.price
    item.save

    redirect_to products_path, notice: t("orders.addedProduct")
  end

  def show
  end

  def checkout
    order = Order.find_by(id: params[:order_id])
    @form_token = nil

    if !@form_token
      result = IzipayService.create_payment(
        amount: (order.order_items.sum { _1.quantity * _1.price } * 100).to_i,
        notificationUrl: izipay_callback_url,
        orderId: order.id
      )

      @form_token = result.dig("answer", "formToken")
    end

    render :checkout
  end

  def success
    @order = Order.find(params[:order_id])

    if request.post?
      redirect_to order_success_path(@order)
    else
    end
  end
end
