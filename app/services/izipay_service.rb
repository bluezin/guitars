class IzipayService
  include HTTParty
  require "base64"
  base_uri ENV["IZIPAY_BASE_URL"]

  def self.create_payment(amount:, notificationUrl:, orderId:)
    token = Base64.strict_encode64("#{ENV['IZIPAY_USERNAME']}:#{ENV['IZIPAY_PASSWORD']}")
    response = post(
      "/api-payment/V4/Charge/CreatePayment",
      headers: {
        "Authorization" => "Basic #{token}",
        "Content-Type" => "application/json"
      },
      body: {
        amount: amount,
        currency: "PEN",
        orderId: orderId,
        notificationUrl: notificationUrl
      }.to_json
    )
    response.parsed_response
  end

  # -------------------------
  # validar firma
  # -------------------------

  def self.valid_signature?(data)
    return false unless data["kr-hash-algorithm"] == "sha256_hmac"

    answer = data["kr-answer"]

    hash = OpenSSL::HMAC.hexdigest(
      "sha256",
      ENV["IZIPAY_PASSWORD"],
      answer
    )

    Rails.logger.info "IZIPAY HASH CALCULADO: #{hash}"
    Rails.logger.info "IZIPAY HASH RECIBIDO: #{data['kr-hash']}"

    ActiveSupport::SecurityUtils.secure_compare(
      hash,
      data["kr-hash"]
    )
  end

  # -------------------------
  # consultar API Izipay
  # -------------------------

  def self.fetch_payment(order_id)
    auth = Base64.strict_encode64(
      "#{ENV['IZIPAY_USERNAME']}:#{ENV['IZIPAY_PASSWORD']}"
    )

    response = HTTParty.post(
      "#{ENV['IZIPAY_BASE_URL']}/api-payment/V4/Charge/Get",
      headers: {
        "Authorization" => "Basic #{auth}",
        "Content-Type" => "application/json"
      },
      body: {
        orderId: order_id
      }.to_json
    )

    JSON.parse(response.body)
  end

  # -------------------------
  # actualizar orden local
  # -------------------------

  def self.update_order(order_id, answer)
    order = Order.find_by(id: order_id)
    return unless order

    return head :ok if order.mp_payment_id.present?

    status = answer.dig("orderStatus")

    if status == "PAID"
      order.update!(
        status: :approved,
        mp_payment_id: answer["orderId"],
        paid_at: Time.current
      )
    else
      order.update!(
        status: "failed",
      )
    end
  end
end
