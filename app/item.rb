class Item
  attr_reader :price, :product_code, :product_name

  def initialize(product_code, product_name, price)
    @product_code = product_code
    @product_name = product_name
    @price = price
  end
end
