class PricingRule
  TYPES = [
    :x_for_y,
    :bulk_discount,
    :free_product_for_every_x_product,
    :promo_code
  ]

  # The rule_params needed depends on the type of the PricingRule

  # for :x_for_y pricing_rules, rules_params must have :min_quantity and :items_to_pay_for
  # where :min_quantity is the minimum quantity of the products in the cart for the rule to be applied
  # where :items_to_pay_for is the amount of the products to pay for
  # so for PricingRule.new('ult_small', :x_for_y, {min_quantity: 3, items_to_pay_for: 2})
  # for every 3 'ult_small' item in the cart, only 2 of those would count towards the total amount

  # for :bulk_discount, rules_params must have :min_quantity and :discounted_price
  # where :min_quantity is the minimum quantity of the products in the cart for the rule to be applied
  # where :discounted_price is the new price of the item in the shopping cart

  # for :apply_free_product_for_every_x_product, rules_params must have :min_quantity and :free_product
  # where :min_quantity is the minimum quantity of the products in the cart for the rule to be applied
  # where :free_product is the product to be given away for free. it must be an Item object

  # for :promo_code, rules_params must have :promo_code and :discount
  # where :promo_code is the code that customers must enter
  # where :discount is the percentage of discount that would be applied across the board
  def initialize(type, rule_params, product_code = nil)
    @product_code = product_code
    unless TYPES.include?(type)
      raise 'Invalid rule type!'
    end
    @type = type
    @rule_params = rule_params
  end

  def apply_rule(shopping_cart)
    if @type == :promo_code
      apply_promo_code(shopping_cart)
      return
    end
    products = products_for_this_rule(shopping_cart)
    return if products.empty?
    individual_price = products[0].price
    self.send("apply_#{@type}".to_sym, shopping_cart, products, individual_price)
  end

  private

  def products_for_this_rule(shopping_cart)
    shopping_cart.items.select { |item| item.product_code == @product_code }
  end

  def apply_x_for_y(shopping_cart, products, individual_price)
    times_rule_is_met = (products.length / @rule_params[:min_quantity])
    deduction_to_apply = times_rule_is_met * (individual_price * (@rule_params[:min_quantity] - @rule_params[:items_to_pay_for]))
    shopping_cart.deductions += deduction_to_apply
  end

  def apply_bulk_discount(shopping_cart, products, individual_price)
    return if products.length < @rule_params[:min_quantity]
    deductions_to_apply = (products.length * (individual_price - @rule_params[:discounted_price]))
    shopping_cart.deductions += deductions_to_apply
  end

  def apply_free_product_for_every_x_product(shopping_cart, products, individual_price)
    times_rule_is_met = (products.length / @rule_params[:min_quantity])
    times_rule_is_met.times do |_n|
      shopping_cart.add_free_item(@rule_params[:free_product])
    end
  end

  def apply_promo_code(shopping_cart)
    if shopping_cart.promo_codes.include?(@rule_params[:promo_code])
      shopping_cart.add_global_discount(@rule_params[:discount])
    end
  end
end
