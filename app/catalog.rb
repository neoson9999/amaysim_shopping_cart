class Catalog
  attr_reader :items

  def initialize(items = [])
    @items = items
  end

  def add(item)
    @items << item
  end

  def get_item_with_code(product_code)
    @items.find { |item| item.product_code == product_code }
  end
end
