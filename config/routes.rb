Rails.application.routes.draw do
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	resources :items
	resources :baskets do
		post :checkout, on: :member
	end
	resources :basket_items

	root "items#index"
end
