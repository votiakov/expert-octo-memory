class BasketItemsController < ApplicationController
	def create
		if resource_type == 'Item'
			add_item
		else
			add_promotion
		end
	end

	def add_item
		# @basket_item = BasketItem.new(basket_item_params)
		@basket_item = BasketItem.where(
			basket_id: params[:basket_item][:basket_id],
			resource_id: params[:basket_item][:resource_id]
		).first

		if @basket_item.present?
			new_quantity = params[:basket_item][:quantity].to_i + @basket_item.quantity
			@basket_item.quantity = new_quantity
		else
			@basket_item = BasketItem.new(basket_item_params)
		end

		if @basket_item.save
			# redirect_to basket_path(id: Basket.first.id)
			flash[:notice] = "Item successfully added"
			redirect_to items_path
		else
			flash[:alert] = "Error: could not add item"
			redirect_to items_path
		end

	end

	def add_promotion
		# byebug
		@promotion = Promotion.find_by_code(params[:basket_item][:promo_code])
		if @promotion
			@basket_item = BasketItem.new(basket_item_params.merge(resource_id: @promotion.id))

			if @basket_item.save
				# redirect_to basket_path(id: Basket.first.id)
				flash[:notice] = "Promo code successfully added"
				redirect_to basket_path(id: Basket.first.id)
			else
				flash[:alert] = "Error: could not add a promo code. #{@basket_item.errors.values.join('. ')}"
				redirect_to basket_path(id: Basket.first.id)
			end
		else
			# @basket_item = BasketItem.new(basket_item_params)
			# @basket_item.errors.add(:promo_code, :blank, message: "does not exist")
			flash[:alert] = "Promotion does not exist"
			redirect_to basket_path(id: Basket.first.id)
		end
	end

	def destroy
		@basket_item = BasketItem.find(params[:id])
		if @basket_item.destroy
			flash[:notice] = "Item removed"
			redirect_to basket_path(id: Basket.first.id)
		else
			flash[:alert] = "Error: could not remove an item"
			redirect_to basket_path(id: Basket.first.id)
		end
	end

  private

	def resource_type
		params[:basket_item][:resource_type]
	end

    def basket_item_params
      params.require(:basket_item).permit(
        :basket_id,
        :resource_id,
        :resource_type,
        :quantity
      )
    end
end