# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  email      :string
#  address    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Customer < ApplicationRecord
	attr_accessor 	:card_number, :card_cvv,
					:card_expiry_month, :card_expiry_year

	has_many :orders, inverse_of: :customer

	validates :email, presence: true, uniqueness: true
	validates_format_of :email, :with => /\A[^@,\s]+@[^@,\s]+\.[^@,\s]+\z/
	validates :address, :card_number, :card_cvv, :card_expiry_month, :card_expiry_year, presence: true
end
