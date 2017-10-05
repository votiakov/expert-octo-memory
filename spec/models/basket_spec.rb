# == Schema Information
#
# Table name: baskets
#
#  id          :integer          not null, primary key
#  checked_out :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

describe Basket do
	it "has a valid factory" do
		expect(build(:basket)).to be_valid
	end

	let(:basket) { build(:basket) }

	describe "db columns" do
		it { expect(basket).to have_db_column(:id).of_type(:integer) }
		it { expect(basket).to have_db_column(:checked_out).of_type(:boolean) }
		it { expect(basket).to have_db_column(:created_at).of_type(:datetime) }
		it { expect(basket).to have_db_column(:updated_at).of_type(:datetime) }
	end

	describe "associations" do
		it { expect(basket).to have_many(:basket_items).dependent(:destroy) }
		it { expect(basket).to have_one(:order) }
		it { expect(basket).to have_many(:items).through(:basket_items) }
		it { expect(basket).to have_many(:promotions).through(:basket_items) }
	end

	describe "public instance methods" do
		context "responds to its methods" do
			it { expect(basket).to respond_to(:items_total) }
			it { expect(basket).to respond_to(:calculate_product_discounts) }
			it { expect(basket).to respond_to(:calculate_amount_discounts) }
			it { expect(basket).to respond_to(:added_promotion_item_ids) }
			it { expect(basket).to respond_to(:number_of_items) }
			it { expect(basket).to respond_to(:total_with_promotions) }
		end

		context "executes methods correctly" do
			let!(:basket_item1)     { create(:item_basket_item) }
			let!(:basket_item2)     { create(:item_basket_item) }

			let!(:basket_item_5_items) { create(:item_basket_item, quantity: 5) }

			let!(:product_promotion)    { create(:product_promotion, quantity: 1) }
			let!(:amount_promotion)     { create(:amount_promotion, can_combine: true) }
			let!(:amount_promotion2)     { create(:amount_promotion, can_combine: true) }
			let!(:basket_product_promotion)     { create(:promotion_basket_item, resource: product_promotion) }
			let!(:basket_amount_promotion)     { create(:promotion_basket_item, resource: amount_promotion ) }
			let!(:basket_amount_promotion2)     { create(:promotion_basket_item, resource: amount_promotion2 ) }
			let!(:promoted_basket_item) { create(:item_basket_item, resource: product_promotion.item) }

			context "#items_total" do
				it 'calculates total price of 2 basket items' do
					current_basket = create(:basket, basket_items: [basket_item1, basket_item2])
					expect(current_basket.items_total).to eq(basket_item1.price + basket_item2.price)
				end

				it 'calculates price of single item times 5' do
					current_basket = create(:basket, basket_items: [basket_item_5_items])
					expect(current_basket.items_total).to eq(basket_item_5_items.price * 5)
				end
			end

			context "#number_of_items" do
				it 'calculates total quantity' do
					current_basket = create(:basket, basket_items: [basket_item1, basket_item2])
					expect(current_basket.number_of_items).to eq(2)
				end

				it 'calculates total quantity' do
					current_basket = create(:basket, basket_items: [basket_item_5_items])
					expect(current_basket.number_of_items).to eq(5)
				end
			end

			context "#added_promotion_item_ids" do
				it 'returns empty array when no product promotions added' do
					current_basket = create(:basket, basket_items: [basket_item1, basket_item2, basket_item_5_items])
					expect(current_basket.added_promotion_item_ids).to eq([])
				end

				it 'returns product_promotion.item.id as an id of the basket item with promotion applied' do
					current_basket = create(:basket, basket_items: [basket_item1, basket_item2, basket_item_5_items, basket_product_promotion, promoted_basket_item])
					expect(current_basket.added_promotion_item_ids).to eq([product_promotion.item.id])
				end
			end


			context "#calculate_product_discounts" do
				it 'returns 0 when no product promotions added' do
					current_basket = create(:basket, basket_items: [basket_item1, basket_item2, basket_item_5_items])
					expect(current_basket.calculate_product_discounts).to eq(0)
				end

				it 'returns product_promotion.price - product_promotion.value when one promoted product added ' do
					current_basket = create(:basket, basket_items: [basket_item1, basket_item2, basket_item_5_items, basket_product_promotion, promoted_basket_item])
					expect(current_basket.calculate_product_discounts).to eq(product_promotion.price - product_promotion.value)
				end

				it 'returns 3 * (product_promotion.price - product_promotion.value) when 3 promoted product added ' do
					promoted_basket_item.update(quantity: 3)
					current_basket = create(:basket, basket_items: [basket_item1, basket_item2, basket_item_5_items, basket_product_promotion, promoted_basket_item])
					expect(current_basket.calculate_product_discounts).to eq(3 * (product_promotion.price - product_promotion.value))
				end

				it 'returns 0 when less items then promotion quantity added' do
					promoted_basket_item.update(quantity: 3)
					product_promotion.update(quantity: 5)
					current_basket = create(:basket, basket_items: [basket_item1, basket_item2, basket_item_5_items, basket_product_promotion, promoted_basket_item])
					expect(current_basket.calculate_product_discounts).to eq(0)
				end
			end

			context "#calculate_amount_discounts" do
				it 'returns 0 when no amount promotions added' do
					current_basket = create(:basket, basket_items: [basket_item1, basket_item2, basket_item_5_items])
					expect(current_basket.calculate_amount_discounts).to eq(0)
				end

				it 'returns amount_promotion.value when applied' do
					current_basket = create(:basket, basket_items: [basket_item1, basket_item2, basket_item_5_items, basket_amount_promotion])
					expect(current_basket.calculate_amount_discounts).to eq(amount_promotion.value)
				end

				it 'returns amount promotions sum when few applied' do
					current_basket = create(:basket, basket_items: [basket_item1, basket_item2, basket_item_5_items, basket_amount_promotion, basket_amount_promotion2])
					expect(current_basket.calculate_amount_discounts).to eq(amount_promotion.value + amount_promotion2.value)
				end
			end

			context "#total_with_promotions" do
				it 'returns items sum when no promotions applied' do
					current_basket = create(:basket, basket_items: [basket_item1, basket_item2, basket_item_5_items])
					expect(current_basket.total_with_promotions).to eq(basket_item1.price + basket_item2.price + basket_item_5_items.price * 5)
				end

				it 'returns items sum - amount promotion when amount promotion applied' do
					amount_promotion.update(value: 1)
					current_basket = create(:basket, basket_items: [basket_item1, basket_item2, basket_item_5_items, basket_amount_promotion])
					expect(current_basket.total_with_promotions).to eq(basket_item1.price + basket_item2.price + basket_item_5_items.price * 5 - amount_promotion.value)
				end

				it 'returns 0.1 when total promotion is higher than total price' do
					amount_promotion.update(value: basket_item1.price + basket_item2.price + basket_item_5_items.price * 5 + 10)
					current_basket = create(:basket, basket_items: [basket_item1, basket_item2, basket_item_5_items, basket_amount_promotion])
					expect(current_basket.total_with_promotions).to eq(0.1)
				end
			end
		end
	end
end
