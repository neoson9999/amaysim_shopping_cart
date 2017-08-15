require './app/shopping_cart'
require './app/pricing_rule'
require './app/item'

describe ShoppingCart do
  let(:pricing_rules) do
    [
      PricingRule.new(:promo_code, {promo_code: 'I<3AMAYSIM', discount: 10})
    ]
  end
  let(:shopping_cart) { ShoppingCart.new(pricing_rules) }
  let(:item) { Item.new('ult_large', 'Unlimited 5GB', 44.9) }
  let(:free_item) { Item.new('1gb', '1 GB Data-pack', 9.9) }

  describe '#add' do
    it 'should add the item to the paid_items instance variable' do
      expect { shopping_cart.add(item) }.to change { shopping_cart.instance_variable_get(:@paid_items).count }.by(1)
    end

    context 'when promo_code is given' do
      it 'should add the promo code to the promo_codes instance variable' do
        expect { shopping_cart.add(item, 'I<3AMAYSIM') }.to change { shopping_cart.instance_variable_get(:@promo_codes).count }.by(1)
      end
    end
  end

  describe '#add_free_item' do
    it 'should add the item to the free_items instance variable' do
      expect { shopping_cart.add_free_item(item) }.to change { shopping_cart.instance_variable_get(:@free_items).count }.by(1)
    end
  end

  describe '#add_global_discount' do
    it 'should add the discount to the global_discount instance variable' do
      expect { shopping_cart.add_global_discount(10) }.to change { shopping_cart.instance_variable_get(:@global_discount) }.by(10)
    end
  end

  describe '#total' do
    it 'should return a float object' do
      expect(shopping_cart.total).to be_a(Float)
    end
  end

  describe '#items' do
    before do
      shopping_cart.add(item)
      shopping_cart.add_free_item(free_item)
    end

    it 'should return a concatenated instance of paid_items and free_items' do
      items = shopping_cart.items
      expect(items.include?(item)).to be_truthy
      expect(items.include?(free_item)).to be_truthy
    end
  end
end
