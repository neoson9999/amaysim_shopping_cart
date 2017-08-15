require './app/catalog'
require './app/item'

describe Catalog do
	let(:item) { Item.new('ult_small', 'Unlimited 1GB', 24.9) }
	let(:catalog) { Catalog.new }

	describe '#add' do
		it 'should increase catalog.items count by 1' do
			expect { catalog.add(item) }.to change { catalog.items.count }.by(1)
		end
	end

	describe '#get_item_with_code' do
		let(:item2) { Item.new('ult_medium', 'Unlimited 2GB', 29.9) }
		let(:item3) { Item.new('ult_large', 'Unlimited 5GB', 44.9) }

		before do
			catalog.add(item)
			catalog.add(item2)
			catalog.add(item3)
		end

		context 'when given product_code exists' do
			it 'should return the correct item' do
				result = catalog.get_item_with_code('ult_medium')
				expect(result).to eql(item2)
			end
		end

		context 'when given product_code does not exist' do
			it 'should return nil' do
				expect(catalog.get_item_with_code('some_other_product')).to be_falsey
			end
		end
	end
end
