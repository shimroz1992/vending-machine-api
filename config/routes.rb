Rails.application.routes.draw do
  resources :products
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/deposit' => 'products#deposit', as: :deposit
  post '/buy' => 'products#buy', as: :buy
  post '/reset' => 'products#reset'
  resources :users, param: :_username
  post '/login', to: 'authentication#login'
  get '/*a', to: 'application#not_found'
  post 'logout/all' => 'authentication#logout'
end
