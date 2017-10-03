class BasketsController < ApplicationController
	def show
		@basket = Basket.first
		@basket_items = @basket.items
		@basket_item = @basket.basket_items.new
	end
end