class MercadoPagoClient
  def self.headers
    {
      "Authorization" => "Bearer #{ENV['MP_ACCESS_TOKEN']}",
      "Content-Type" => "application/json"
    }
  end

  def self.create_preference(body)
    response = HTTParty.post(
      "#{ENV['API_URL_MERCADO_PAGO']}/checkout/preferences",
      headers: headers,
      body: body,
      ssl_ca_file: ENV["SSL_CERT_FILE"]
    )
    body = JSON.parse(response.body)

    body
  end

  def self.get_payment(payment_id)
    response = HTTParty.get(
      "#{ENV['API_URL_MERCADO_PAGO']}/v1/payments/#{payment_id}",
      headers: headers,
      ssl_ca_file: ENV["SSL_CERT_FILE"]
    )
    JSON.parse(response.body)
  end
end
