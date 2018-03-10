Rails.application.routes.draw do
  	

	# devise_for :users
    root :to => "home#index"
    get '/signup' => 'home#new'
    get '/login' => 'sessions#new'
    post '/login' => 'sessions#create'
    delete '/logout' => 'sessions#destroy'
    resources :users do
      collection do
        get :forget_password
        patch :change_password
      end
    end
    resources :home
    resources :transactions
end
