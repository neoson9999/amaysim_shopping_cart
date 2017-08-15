require './app/pricing_rule'
require './app/item'
require './app/shopping_cart'

describe PricingRule do
	let(:item) { Item.new('ult_small', 'Unlimited 1GB', 24.9) }
	let(:shopping_cart) { ShoppingCart.new([pricing_rule]) }
	let(:items) { [item, item, item, item, item, item] }

	describe '#apply_rule' do
		context 'when pricing rule is :x_for_y type' do
			context 'when 3 for 2' do
				let(:pricing_rule) { PricingRule.new(:x_for_y, {min_quantity: 3, items_to_pay_for: 2}, item.product_code) }

				context 'when there are 3 items in the cart' do
					before do
						shopping_cart.instance_variable_set(:@paid_items, items.slice(0, 3))
						pricing_rule.apply_rule(shopping_cart)
					end

					it 'should apply the correct amount of deduction to the shopping_cart' do
						expect(shopping_cart.deductions).to eql(item.price)
					end

					it 'should apply the correct total to the shopping_cart' do
						expect(shopping_cart.total).to be_within(0.00001).of(item.price * 2)
					end
				end

				context 'when there are 6 items in the cart' do
					before do
						shopping_cart.instance_variable_set(:@paid_items, items)
						pricing_rule.apply_rule(shopping_cart)
					end

					it 'should apply the correct amount of deduction to the shopping_cart' do
						expect(shopping_cart.deductions).to eql(item.price * 2)
					end

					it 'should apply the correct total to the shopping_cart' do
						expect(shopping_cart.total).to be_within(0.00001).of(item.price * 4)
					end
				end
			end

			context 'when 5 for 4' do
				let(:pricing_rule) { PricingRule.new(:x_for_y, {min_quantity: 5, items_to_pay_for: 4}, item.product_code) }

				before do
					shopping_cart.instance_variable_set(:@paid_items, items.slice(0, 5))
					pricing_rule.apply_rule(shopping_cart)
				end

				it 'should apply the correct amount of deduction to the shopping_cart' do
					expect(shopping_cart.deductions).to eql(item.price)
				end

				it 'should apply the correct total to the shopping_cart' do
					expect(shopping_cart.total).to be_within(0.00001).of(item.price * 4)
				end
			end
		end

		context 'when pricing_rule is :bulk_discount' do
			let(:new_price) { 20 }
			let(:pricing_rule) { PricingRule.new(:bulk_discount, {min_quantity: 4, discounted_price: new_price}, item.product_code) }

			context 'when there are 4 items in the cart' do
				before do
					shopping_cart.instance_variable_set(:@paid_items, items.slice(0, 4))
					pricing_rule.apply_rule(shopping_cart)
				end

				it 'should apply the correct amount of deduction to the shopping_cart' do
					expect(shopping_cart.deductions).to eql((item.price - new_price) * 4)
				end

				it 'should apply the correct total to the shopping_cart' do
					expect(shopping_cart.total).to be_within(0.00001).of(new_price * 4)
				end
			end

			context 'when there are 5 items in the cart' do
				before do
					shopping_cart.instance_variable_set(:@paid_items, items.slice(0, 5))
					pricing_rule.apply_rule(shopping_cart)
				end

				it 'should apply the correct amount of deduction to the shopping_cart' do
					expect(shopping_cart.deductions).to eql((item.price - new_price) * 5)
				end

				it 'should apply the correct total to the shopping_cart' do
					expect(shopping_cart.total).to be_within(0.00001).of(new_price * 5)
				end
			end
		end

		context 'when pricing_rule is :free_product_for_every_x_product' do
			let(:pricing_rule) do
				PricingRule.new(:free_product_for_every_x_product, {min_quantity: 1, free_product: free_item}, item.product_code)
			end
			let(:free_item) { Item.new('1gb', '1 GB Data-pack', 9.9) }

			after { pricing_rule.apply_rule(shopping_cart) }

			context 'when there is 1 item in the cart' do
				before do
					shopping_cart.add(item)
				end

				it 'should call #add_free_item method of the shopping_cart' do
					expect(shopping_cart).to receive(:add_free_item)
				end
			end

			context 'when there are 3 items in the cart' do
				before do
					shopping_cart.instance_variable_set(:@paid_items, items.slice(0, 3))
				end

				it 'should call #add_free_item thrice' do
					expect(shopping_cart).to receive(:add_free_item).thrice
				end
			end
		end

		context 'when pricing_rule is :promo_code' do
			let(:pricing_rule) { PricingRule.new(:promo_code, {promo_code: 'I<3AMAYSIM', discount: 10}) }

			context 'when shopping_cart has a valid promo code' do
				before { shopping_cart.add(item, 'I<3AMAYSIM') }

				it 'should call #add_global_discount method of the shopping_cart' do
					expect(shopping_cart).to receive(:add_global_discount)
					pricing_rule.apply_rule(shopping_cart)
				end
			end

			context 'when shopping_cart does not have a valid promo code' do
				before { shopping_cart.add(item, 'INVALIDPROMOCODE') }

				it 'should not call #add_global_discount method of the shopping_cart' do
					expect(shopping_cart).to receive(:add_global_discount).never
					pricing_rule.apply_rule(shopping_cart)
				end
			end
		end
	end
end
