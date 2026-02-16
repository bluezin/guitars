class IzipayService
  include HTTParty
  require "base64"
  base_uri ENV["IZIPAY_BASE_URL"]

  def self.create_payment(amount:, email:, notificationUrl:)
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
        orderId: SecureRandom.hex(6),
        customer: { email: email },
        notificationUrl: notificationUrl
      }.to_json
    )
    response.parsed_response
  end

  # -------------------------
  # validar firma
  # -------------------------

  def self.valid_signature?(data, key)
    return false unless data["kr-hash-algorithm"] == "sha256_hmac"

    answer = data["kr-answer"]

    hash = OpenSSL::HMAC.hexdigest(
      "sha256",
      ENV["IZIPAY_SHA_KEY"],
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

  def self.update_order(order_id, payment)
    order = Order.find_by(reference: order_id)
    return unless order

    status = payment.dig("status")

    if status == "PAID"
      order.update!(
        status: "paid",
        paid_at: Time.current,
        gateway_response: payment
      )
    else
      order.update!(
        status: "failed",
        gateway_response: payment
      )
    end
  end
end
