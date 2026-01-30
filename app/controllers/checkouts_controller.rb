require "net/http"
require "json"

class CheckoutsController < ApplicationController
  protect_from_forgery with: :null_session
  allow_unauthenticated_access only: %i[create success failure pending]

  def create
    order = Order.find(params[:order_id])

    body = {
      items: order.order_items.map do |item|
        {
          title: item.product.name,
          quantity: item.quantity,
          unit_price: (item.quantity * item.price).to_i,
          currency_id: "PEN"
        }
      end,
      back_urls: {
        success: "#{ENV['APP_URL']}/success",
        failure: "#{ENV['APP_URL']}/failure",
        pending: "#{ENV['APP_URL']}/pending"
      },
      external_reference: order.id.to_s,
      notification_url: "#{ENV['APP_URL']}/webhooks/mercadopago"
    }.to_json

    response = MercadoPagoClient.create_preference(body)

    redirect_url =
      if Rails.env.development?
        response["init_point"]
      else
        response["init_point"]
      end

    redirect_to redirect_url, allow_other_host: true
  end

  def success
    @order = Order.find_by(id: params[:external_reference])

    render :success
  end

  def failure
    render plain: "Pago fallido"
  end

  def pending
    render plain: "Pago pendiente"
  end
end
