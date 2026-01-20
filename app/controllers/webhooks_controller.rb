class WebhooksController < ApplicationController
  skip_before_action :require_authentication
  skip_before_action :current_order
  skip_before_action :verify_authenticity_token

  def mercadopago
    Rails.logger.info "🔥 WEBHOOK RECIBIDO"
    Rails.logger.info params.to_unsafe_h

    topic = params[:type] || params[:topic]
    return head :ok unless topic == "payment"

    payment_id =
      params.dig("data", "id") ||
      params[:id]

    return head :ok unless payment_id

    payment = MercadoPagoClient.get_payment(payment_id)

    order = Order.find_by(id: payment["external_reference"])
    return head :ok unless order

    case payment["status"]
    when "approved"
      order.update!(
        status: :approved,
        mp_payment_id: payment["id"],
        paid_at: Time.current
      )
    when "rejected", "cancelled"
      order.update!(status: :failed)
    else
      order.update!(status: :pending)
    end

    head :ok
  end
end
