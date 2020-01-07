Rails.application.routes.draw do
  namespace :api do
    resources :users
    post 'auth/register', to: 'users#register'
    post 'auth/login', to: 'users#login'
    get 'test', to: 'users#test'
    post 'chatroom/:id', to: 'chatrooms#send_message'
    get 'chatrooms', to: 'chatrooms#index'
    get 'chatroom/:id', to: 'chatrooms#show' 
    get 'connect', to: 'users#connect'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end