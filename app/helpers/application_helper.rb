module ApplicationHelper
  def format_price(price)
    number_with_delimiter(price.to_i, delimiter: ",")
  end
end
