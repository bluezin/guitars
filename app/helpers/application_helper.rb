module ApplicationHelper
  def format_price(price)
    formatted = format("%.2f", price)
    formatted = formatted.sub(/\.?0+$/, "") if formatted.end_with?(".00")
    number_with_delimiter(formatted, delimiter: ",", separator: ".")
  end

  def sale_percent_badge(product)
    return unless product.discounted?

    tag.span "-#{product.active_discount_percent}%", class: "sale-badge"
  end

  def price_html(product)
    caption = +""
    if product.discounted?
      caption << tag.span(format_price(product.price), class: "price-original")
      caption << " "
    end
    caption << tag.span(format_price(product.sale_price), class: "price-sale")
    caption.html_safe
  end
end
