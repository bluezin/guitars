class ApplicationController < ActionController::Base
  before_action :current_order
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def current_order
    @order = Order.find_by(id: session[:order_id], status: "pending")

    unless @order
      @order = Order.create(status: "pending")
      session[:order_id] = @order.id
    end
  end
end
