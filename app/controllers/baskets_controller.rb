class BasketsController < ApplicationController
	def index
		if current_basket.persisted?
			# render 'show'
			redirect_to basket_path(current_basket.id)
		else
			render 'empty'
		end
	end

	def show
		@basket = current_basket
	end
end