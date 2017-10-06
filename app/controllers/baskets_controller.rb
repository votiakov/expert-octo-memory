class BasketsController < ApplicationController
	def index
		if current_basket.persisted?
			redirect_to basket_path(current_basket.id)
		else
			render 'empty'
		end
	end

	def show
		@basket = current_basket
	end

	def destroy
		@basket = current_basket
		if @basket.destroy
			flash[:notice] = "Basket cleared"
			redirect_to baskets_path
		else
			flash[:alert] = "Error: could not clear the basket"
		end
	end
end