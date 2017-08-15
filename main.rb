Dir['./app/*'].each { |file| require file }

def setup_default_products
	@catalog = Catalog.new
	@catalog.add(Item.new('ult_small', 'Unlimited 1GB', 24.9))
	@catalog.add(Item.new('ult_medium', 'Unlimited 2GB', 29.9))
	@catalog.add(Item.new('ult_large', 'Unlimited 5GB', 44.9))
	@catalog.add(Item.new('1gb', '1 GB Data-pack', 9.9))
end

def setup_default_rules
	@pricing_rules = []
	@pricing_rules << PricingRule.new(:x_for_y, {min_quantity: 3, items_to_pay_for: 2}, 'ult_small')
	@pricing_rules << PricingRule.new(:bulk_discount, {discounted_price: 39.9, min_quantity: 4}, 'ult_large')

	rule_params = {
		free_product: @catalog.get_item_with_code('1gb'),
		min_quantity: 1
	}
	@pricing_rules << PricingRule.new(:free_product_for_every_x_product, rule_params, 'ult_medium')
	@pricing_rules << PricingRule.new(:promo_code, {promo_code: 'I<3AMAYSIM', discount: 10})
end

def setup_defaults
	setup_default_products
	setup_default_rules
end

def format_items(items)
	items_by_product_code = items.group_by { |item| item.product_code }
	count_per_item = items_by_product_code.map do |product_code, items|
		item_name = items[0].product_name
		quantity = items.length
		[quantity, item_name]
	end
	p "Cart Items"
	count_per_item.each do |item_quantity_name|
		p "#{item_quantity_name[0]} X #{item_quantity_name[1]}"
	end
end

def format_total(total)
	p "Total: $#{total}"
end

def scenario_1
	setup_defaults
	p 'scenario 1'
	sc = ShoppingCart.new(@pricing_rules)
	sc.add(@catalog.get_item_with_code('ult_small'))
	sc.add(@catalog.get_item_with_code('ult_small'))
	sc.add(@catalog.get_item_with_code('ult_small'))
	sc.add(@catalog.get_item_with_code('ult_large'))
	format_total(sc.total)
	format_items(sc.items)
end

def scenario_2
	setup_defaults
	p 'scenario 2'
	sc = ShoppingCart.new(@pricing_rules)
	sc.add(@catalog.get_item_with_code('ult_small'))
	sc.add(@catalog.get_item_with_code('ult_small'))
	sc.add(@catalog.get_item_with_code('ult_large'))
	sc.add(@catalog.get_item_with_code('ult_large'))
	sc.add(@catalog.get_item_with_code('ult_large'))
	sc.add(@catalog.get_item_with_code('ult_large'))
	format_total(sc.total)
	format_items(sc.items)
end

def scenario_3
	setup_defaults
	p 'scenario 3'
	sc = ShoppingCart.new(@pricing_rules)
	sc.add(@catalog.get_item_with_code('ult_small'))
	sc.add(@catalog.get_item_with_code('ult_medium'))
	sc.add(@catalog.get_item_with_code('ult_medium'))
	format_total(sc.total)
	format_items(sc.items)
end

def scenario_4
	setup_defaults
	p 'scenario 4'
	sc = ShoppingCart.new(@pricing_rules)
	sc.add(@catalog.get_item_with_code('ult_small'))
	sc.add(@catalog.get_item_with_code('1gb'), 'I<3AMAYSIM')
	format_total(sc.total)
	format_items(sc.items)
end

# scenario 1
# sc = ShoppingCart.new(@pricing_rules)
# sc.add(@catalog.get_item_with_code('ult_small'))
# sc.add(@catalog.get_item_with_code('ult_small'))
# sc.add(@catalog.get_item_with_code('ult_small'))
# sc.add(@catalog.get_item_with_code('ult_large'))
# format_total(sc.total)
# format_items(sc.items)

# scenario 2
# sc = ShoppingCart.new(@pricing_rules)
# sc.add(@catalog.get_item_with_code('ult_small'))
# sc.add(@catalog.get_item_with_code('ult_small'))
# sc.add(@catalog.get_item_with_code('ult_large'))
# sc.add(@catalog.get_item_with_code('ult_large'))
# sc.add(@catalog.get_item_with_code('ult_large'))
# sc.add(@catalog.get_item_with_code('ult_large'))
# format_total(sc.total)
# format_items(sc.items)

# scenario 3
# sc = ShoppingCart.new(@pricing_rules)
# sc.add(@catalog.get_item_with_code('ult_small'))
# sc.add(@catalog.get_item_with_code('ult_medium'))
# sc.add(@catalog.get_item_with_code('ult_medium'))
# format_total(sc.total)
# format_items(sc.items)

# scenario 4
# sc = ShoppingCart.new(@pricing_rules)
# sc.add(@catalog.get_item_with_code('ult_small'))
# sc.add(@catalog.get_item_with_code('1gb'), 'I<3AMAYSIM')
# format_total(sc.total)
# format_items(sc.items)
