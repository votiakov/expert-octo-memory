class ItemsController < ApplicationController
	def index
		@items = Item.all
		@product_promotions = Promotion.products
		@basket = current_basket
	end
end
