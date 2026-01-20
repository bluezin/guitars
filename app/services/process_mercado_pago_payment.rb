# app/services/process_mercado_pago_payment.rb
class ProcessMercadoPagoPayment
  def self.call(payment)
    order_id = payment["external_reference"]
    return unless order_id

    order = Order.find_by(id: order_id)
    return unless order

    case payment["status"]
    when "approved"
      order.update!(status: :approved)
      handle_order_items(order)
    when "pending", "in_process"
      order.update!(status: :pending)
    when "rejected", "cancelled"
      order.update!(status: :failed)
    end
  end

  def self.handle_order_items(order)
    order.order_items.each do |item|
      # ejemplo: descontar stock
      # product = item.product
      # product.decrement!(:stock, item.quantity)
    end
  end
end
