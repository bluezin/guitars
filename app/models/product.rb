class Product < ApplicationRecord
  has_many :subscribers, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_rich_text :description
  has_one_attached :featured_image
  has_many_attached :media
  belongs_to :category

  validates :name, presence: true
  validates :inventory_count, numericality: { greater_than_or_equal_to: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :discount_percent, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true

  # Descuento propio del producto; si no tiene, cae al "Cyber Day" global.
  def active_discount_percent
    discount_percent || (Sale.active? ? Sale.percent : 0)
  end

  def discounted?
    active_discount_percent.positive?
  end

  # Precio efectivo tras aplicar el descuento en el catálogo/carrito.
  def sale_price
    return price unless discounted?

    (price - (price * active_discount_percent / 100.0)).round(2)
  end

  # after_update_commit :notify_subscribers, if: :back_in_stock?

  # def back_in_stock
  #   inventory_count_previously_was.zero? && inventory_count.positive?
  # end

  # def notify_subscribers
  #   subscribers.each do |subscriber|
  #     ProductMailer.with(product: self, subscriber: subscriber).in_stock.deliver_later
  #   end
  # end
end
