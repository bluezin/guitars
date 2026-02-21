class OrdersController < ApplicationController
  allow_unauthenticated_access only: %i[add_product checkout success]

  def add_product
    product = Product.find(params[:product_id])
    product.inventory_count -= 1
    product.save

    item = @order.order_items.find_or_initialize_by(product: product)

    item.quantity ||=0
    item.quantity += 1
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
    answer = JSON.parse(params["kr-answer"])
    order_id = answer.dig("orderDetails", "orderId")
    @order = Order.find_by(id: order_id)

    render :success
  end
end
