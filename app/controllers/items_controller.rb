class ItemsController < ApplicationController
	def index
		@items = Item.all
		@basket = current_basket
	end
end
