class PaymentsController < ApplicationController
  require "openssl"
  require "json"
  skip_before_action :require_authentication
  skip_before_action :current_order
  skip_before_action :verify_authenticity_token

  def izipay_callback
    data = params.to_unsafe_h

    unless IzipayService.valid_signature?(data)
      render plain: "Invalid signature", status: :unauthorized
      return
    end

    answer = JSON.parse(data["kr-answer"])
    transaction_id = answer.dig("orderDetails", "orderId")

    # consultar API
    # payment_info = IzipayService.fetch_payment(answer["orderId"]) -> Comentario temporal

    # actualizar orden
    IzipayService.update_order(transaction_id, answer)

    render plain: "OK"
  end
end
