Amaysim Shopping Cart
=====================

**Running the tests**

To run the tests:

    rspec spec

**Running the app and the scenarios**

While inside the amaysim_shopping_cart directory:

    irb -r ./main.rb

This should load irb with all the other classes.

To run the scenarios, type the following in irb:

    scenario_1
    scenario_2
    scenario_3
    scenario_4

**Playing around with the app**

To play around with the app:

      irb -r ./main.rb

initialize a catalog object and add items to it:

    catalog = Catalog.new
    catalog.add(Item.new('ult_small', 'Unlimited 1GB', 24.9))

create a pricing rule:

      pricing_rules = []
      pricing_rules << PricingRule.new(:x_for_y, {min_quantity: 3, items_to_pay_for: 2}, 'ult_small')

PricingRule needs to be provided a type, and a rule_params.
product_code should be provided unless the PricingRule is of the :promo_code type.

There are 4 types accepted:

 - :x_for_y
 - :bulk_discount
 - :free_product_for_every_x_product
 - :promo_code

For **rule_params**, the rule_params needed depends on the type of the PricingRule


for **:x_for_y**, rules_params must have **:min_quantity** and **:items_to_pay_for**

where **:min_quantity** is the minimum quantity of the products in the cart for the rule to be applied
where **:items_to_pay_for** is the amount of the products to pay for

    PricingRule.new(:x_for_y, {min_quantity: 3, items_to_pay_for: 2}, 'ult_small')
This rule would mean for every 3 'ult_small' item in the cart, only 2 of those would count towards the total amount.


for **:bulk_discount**, rules_params must have **:min_quantity** and **:discounted_price**
where **:min_quantity** is the minimum quantity of the products in the cart for the rule to be applied
where **:discounted_price** is the new price of the item in the shopping cart

    PricingRule.new(:bulk_discount, {discounted_price: 39.9, min_quantity: 4}, 'ult_large')
This rule would mean if at least 4 'ult_large' products are added to the cart, a bulk discount will be applied and the 'ult_large' product would cost 39.9 instead.


for **:apply_free_product_for_every_x_product**, rules_params must have **:min_quantity** and **:free_product**
where **:min_quantity** is the minimum quantity of the products in the cart for the rule to be applied
where **:free_product** is the product to be given away for free. it must be an **Item** object

    rule_params = {
      free_product: @catalog.get_item_with_code('1gb'),
      min_quantity: 1
    }
    PricingRule.new(:free_product_for_every_x_product, rule_params, 'ult_medium')
   
This rule would mean for every 1 'ult_medium' added, a free_product '1gb' would be given for free.


for **:promo_code**, rules_params must have **:promo_code** and **:discount**
where **:promo_code** is the code that customers must enter
where **:discount** is the percentage of discount that would be applied across the board

    PricingRule.new(:promo_code, {promo_code: 'I<3AMAYSIM', discount: 10})
This rule would mean that if a user enters an 'I<3AMAYSIM' promo code, he will be given a 10% discount on all his items.

initialize a shopping cart and add items to it:

    sc = ShoppingCart.new(pricing_rules)
    sc.add(catalog.get_item_with_code('ult_small'))
    sc.add(@catalog.get_item_with_code('ult_large'))
    
display the formatted total and list of items:

    format_total(sc.total)
    format_items(sc.items)
