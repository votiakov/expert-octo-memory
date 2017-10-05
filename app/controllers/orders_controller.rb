class OrdersController < ApplicationController
	def create
		@order = Order.new(order_params)
		if @order.save
			flash[:notice] = "Order placed successfully"
			session[:basket_id] = nil
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
		unless current_basket.persisted? && current_basket.items.present?
			flash[:alert] = "Nothing to check out"
			redirect_to baskets_path
		end

		@order = Order.new(basket_id: current_basket.try(:id))
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