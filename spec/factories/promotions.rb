# == Schema Information
#
# Table name: promotions
#
#  id          :integer          not null, primary key
#  kind        :string           not null
#  value       :float
#  code        :string
#  can_combine :boolean          default(FALSE)
#  quantity    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
	factory :promotion do
		can_combine { Faker::Boolean.boolean }
		value { Faker::Number.between(1, 100) }
		code { Faker::Code.asin }

		kind { [:amount, :percent, :product].sample }

		trait :can_combine do
			can_combine true
		end

		trait :cannot_combine do
			can_combine false
		end


		factory :percent_promotion do
			kind :percent
		end

		factory :product_promotion do
			kind :product
			quantity { Faker::Number.between(1, 10) }
			item { create(:item) }
		end

		factory :amount_promotion do
			kind :amount
			value { Faker::Number.between(1, 1000) }
		end
	end
end