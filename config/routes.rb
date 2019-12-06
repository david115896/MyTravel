Rails.application.routes.draw do

  resources :checkouts
  resources :organisers do
    collection { delete :destroy_ticket_cookie}
  end
  #statics views
  root :to => "static#index"
  get 'static/index'

  # mains tables
  devise_for :users
	resources :users, except:[:index, :new, :create]
  resources :cities do
		resources :activities do
			collection { post :import}
		end
	end 
  resources :countries
	
	namespace :admin do
		resources :users
		resources :orders
		resources :activities
	end
  resources :tickets

  #joints tables 
  resources :carts, only: [:index, :create, :destroy]
  resources :organizers, only: [:index, :create, :destroy]
  resources :orders, only: [:index, :create, :destroy]
  resources :sold_tickets, only: [:index, :create, :destroy]


  #service
  resources :charges #stripe

end
