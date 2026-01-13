require "net/http"
require "json"

class CheckoutsController < ApplicationController
  protect_from_forgery with: :null_session
  allow_unauthenticated_access only: %i[create success failure pending]

  def create
    uri = URI("#{ENV['API_URL_MERCADO_PAGO']}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{ENV['MP_ACCESS_TOKEN']}"
    request["Content-Type"] = "application/json"

    request.body = {
      items: [
        {
          title: "Producto prueba",
          quantity: 1,
          unit_price: 100.0,
          currency_id: "PEN"
        }
      ],
      back_url: {
        success: "#{ENV['BASE_URL']}/success",
        failure: "#{ENV['BASE_URL']}/failure",
        pending: "#{ENV['BASE_URL']}/pending"
      }
    }.to_json

    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    response = http.request(request)
    body = JSON.parse(response.body)

    render json: {
      init_point: body["init_point"]
    }
  end

  def success
    render plain: "Pago exitoso"
  end

  def failure
    render plain: "Pago fallido"
  end

  def pending
    render plain: "Pago pendiente"
  end
end
