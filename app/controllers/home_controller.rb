class HomeController < ApplicationController
  def index
  	@items = Item.all

  	@basket = Basket.first
  	@basket_item = @basket.basket_items.new
  end
end
