class PaymentsController < ApplicationController
  require "openssl"
  require "json"
  skip_before_action :require_authentication
  skip_before_action :current_order
  skip_before_action :verify_authenticity_token

  def index
  end

  def new
  end

  def success
  end

  def create
    @form_token = nil

    if !@form_token
      result = IzipayService.create_payment(
        amount: 1000,
        email: "yadiraco304@gmail.com",
        notificationUrl: izipay_callback_url
      )

      @form_token = result.dig("answer", "formToken")
    end

    render :index
  end

  def izipay_callback
    Rails.logger.info "🔥 CALLBACK RECIBIDO"
    data = params.to_unsafe_h

    unless IzipayService.valid_signature?(data, ENV["IZIPAY_SHA_KEY"])
      render plain: "Invalid signature", status: :unauthorized
      return
    end

    answer = JSON.parse(data["kr-answer"])
    transaction_id = answer.dig("orderDetails", "orderId")

    # consultar API
    payment_info = IzipayService.fetch_payment(answer["orderId"])

    # actualizar orden
    IzipayService.update_order(transaction_id, payment_info)

    render plain: "OK"
  end
end
