Rails.application.routes.draw do
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	resources :items
	resources :baskets
	resources :basket_items
	resources :orders

	root "items#index"
end
