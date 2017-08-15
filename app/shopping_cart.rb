class ShoppingCart
  attr_accessor :deductions, :promo_codes

  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
    setup
  end

  def add(item, promo_code = nil)
    @paid_items << item
    @promo_codes << promo_code unless promo_code.nil?
    apply_rules
  end

  def add_free_item(item)
    @free_items << item
  end

  def add_global_discount(discount)
    @global_discount += discount
  end

  def total
    ((total_before_rules - @deductions) * global_discount_percentage).round(2)
  end

  def items
    @paid_items + @free_items
  end

  def reset_cart
    setup
  end

  private

  def setup
    @deductions = 0
    @global_discount = 0
    @free_items = []
    @paid_items = []
    @promo_codes = []
  end

  def apply_rules
    @deductions = 0
    @free_items = []
    @pricing_rules.each { |pricing_rule| pricing_rule.apply_rule(self) }
  end

  def total_before_rules
    @paid_items.reduce(0) { |sum, item| sum + item.price }
  end

  def global_discount_percentage
    (100.0 - @global_discount) / 100.0
  end
end
