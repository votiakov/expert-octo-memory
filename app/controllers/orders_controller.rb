class OrdersController < ApplicationController
	def create
		@order = Order.new(order_params)
		if @order.save
			flash[:notice] = "Order placed successfully"
			redirect_to items_path
		else
			flash[:alert] = "Form contains errors"
			render 'new'
		end
	end

	def index
		redirect_to new_order_path
	end

	def new
		@order = Order.new(basket_id: Basket.first.id)
	end

	def show
		@order = Order.find(params[:id])
	end

	private

		def order_params
			params.require(:order).permit(
				:basket_id,
				customer_attributes: [
					:id,
					:email,
					:address,
					:card_number,
					:card_cvv,
					:card_expiry_month,
					:card_expiry_year
				]
			)
		end
end