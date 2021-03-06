Rails.application.routes.draw do

	root 'static_pages#home'

	get 'users/new'
	get '/home', to: 'static_pages#home'
	get '/help', to: 'static_pages#help'
	get '/about', to: 'static_pages#about'
	get '/contact', to: 'static_pages#contact'
	get '/signup', to: 'users#new'
	get '/login', to: 'sessions#new'

	post '/login', to: 'sessions#create'

	delete '/logout', to: 'sessions#destroy'

	resources :users
	resources :users do
		# responds to routes of user/id
		member do
			# allow to get user's following and user's followers
			get :following, :followers
		end
	end
	resources :account_activations, only: [:edit]
	resources :password_resets, only: [:new, :create, :edit, :update]
	resources :microposts, only: [:create, :destroy]
	resources :relationships, only: [:create, :destroy]
end
