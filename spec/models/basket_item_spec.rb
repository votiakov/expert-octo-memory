# == Schema Information
#
# Table name: basket_items
#
#  id            :integer          not null, primary key
#  resource_type :string
#  resource_id   :integer
#  basket_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  quantity      :integer
#
# Indexes
#
#  index_basket_items_on_basket_id                      (basket_id)
#  index_basket_items_on_resource_type_and_resource_id  (resource_type,resource_id)
#

describe BasketItem do
	it "has a valid factory" do
		expect(build(:basket_item)).to be_valid
		expect(build(:item_basket_item)).to be_valid
		expect(build(:promotion_basket_item)).to be_valid
	end

	let(:basket_item) { build(:basket_item) }
	let(:item_basket_item) { build(:item_basket_item) }
	let(:promotion_basket_item) { build(:promotion_basket_item) }

	describe "db columns" do
		it { expect(basket_item).to have_db_column(:id).of_type(:integer) }
		it { expect(basket_item).to have_db_column(:resource_type).of_type(:string) }
		it { expect(basket_item).to have_db_column(:resource_id).of_type(:integer) }
		it { expect(basket_item).to have_db_column(:basket_id).of_type(:integer) }
		it { expect(basket_item).to have_db_column(:updated_at).of_type(:datetime) }
		it { expect(basket_item).to have_db_column(:created_at).of_type(:datetime) }
		it { expect(basket_item).to have_db_column(:quantity).of_type(:integer) }

	    it { expect(basket_item).to have_db_index(:basket_id) }
	    it { expect(basket_item).to have_db_index([:resource_type, :resource_id]) }
	end

	describe "associations" do
		it { expect(basket_item).to belong_to(:basket) }
		it { expect(basket_item).to belong_to(:resource) }
	end

	describe "validations" do
		it { expect(basket_item).to validate_presence_of(:quantity) }

		it { expect(promotion_basket_item).to validate_uniqueness_of(:resource_id).scoped_to([:basket_id, :resource_type]).with_message("This promo code is already used") }
		it { expect(item_basket_item).to_not validate_uniqueness_of(:resource_id).scoped_to([:basket_id, :resource_type]) }

		context '#combining_codes' do
			let!(:current_basket) { create(:basket) }
			let!(:item_basket_item) { create(:item_basket_item, basket: current_basket) }

			let!(:amount_promotion_can) { create(:amount_promotion, :can_combine) }
			let!(:amount_promotion2_can) { create(:amount_promotion, :can_combine) }
			let!(:percent_promotion_can) { create(:percent_promotion, :can_combine) }
			let!(:percent_promotion2_can) { create(:percent_promotion, :can_combine) }

			let!(:promotion_basket_item1) { create(:promotion_basket_item, basket: current_basket, resource: amount_promotion_can) }
			let!(:promotion_basket_item2) { create(:promotion_basket_item, basket: current_basket, resource: amount_promotion2_can) }
			let!(:promotion_basket_item3) { create(:promotion_basket_item, basket: current_basket, resource: percent_promotion_can) }
			let!(:promotion_basket_item4) { create(:promotion_basket_item, basket: current_basket, resource: percent_promotion2_can) }

			let!(:amount_promotion3_can) { create(:amount_promotion, :can_combine) }

			let!(:amount_promotion_cannot) { create(:amount_promotion, :cannot_combine) }

			context 'valid' do
				let(:promotion_basket_item_valid) { build(:promotion_basket_item, basket: current_basket, resource: amount_promotion3_can) }

				it "passes validation" do
					expect(promotion_basket_item_valid).to be_valid
					expect { promotion_basket_item_valid.save }.to change { BasketItem.count }.by(1)
				end
				it "does not throw any error" do
					promotion_basket_item_valid.valid?
					expect(promotion_basket_item_valid.errors.size).to eq(0)
				end
			end

			context 'invalid' do
				context "add not combinable code to already added codes" do
					let(:promotion_basket_item_invalid) { build(:promotion_basket_item, basket: current_basket, resource: amount_promotion_cannot) }
					it "does not pass validation" do
						promotion_basket_item_invalid.valid?
						expect(promotion_basket_item_invalid).to_not be_valid
					end
					it "add 1 error to errors array" do
						promotion_basket_item_invalid.valid?
						expect(promotion_basket_item_invalid.errors[:base].size).to eq(1)
					end
					it "provides correct error message" do
						promotion_basket_item_invalid.valid?
						expect(promotion_basket_item_invalid.errors[:base].first).to eq('This code cannot be used in conjunction with other codes')
					end
				end

				context "add combinable code to already added not combinable code" do
					let!(:current_basket2) { create(:basket) }
					let!(:item_basket_item) { create(:item_basket_item, basket: current_basket2) }

					let!(:amount_promotion_cannot) { create(:amount_promotion, :cannot_combine) }

					let!(:amount_promotion_can) { create(:amount_promotion, :can_combine) }

					let!(:promotion_basket_item_cannot) { create(:promotion_basket_item, basket: current_basket2, resource: amount_promotion_cannot) }

					let(:promotion_basket_item_invalid) { build(:promotion_basket_item, basket: current_basket2, resource: amount_promotion_can) }
					it "does not pass validation" do
						promotion_basket_item_invalid.valid?
						expect(promotion_basket_item_invalid).to_not be_valid
					end
					it "add 1 error to errors array" do
						promotion_basket_item_invalid.valid?
						expect(promotion_basket_item_invalid.errors[:base].size).to eq(1)
					end
					it "provides correct error message" do
						promotion_basket_item_invalid.valid?
						expect(promotion_basket_item_invalid.errors[:base].first).to eq('You already used a code that cannot be used in conjunction with other codes')
					end
				end
			end
		end
	end
end