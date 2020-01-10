Rails.application.routes.draw do
  namespace :api do
    resources :users
    post 'auth/register', to: 'users#register'
    post 'auth/login', to: 'users#login'
    get 'connection', to: 'chatrooms#get_connect'
    post 'connection', to: 'users#connect'
    delete 'connection', to: 'users#disconnect'
    post 'chatrooms/:id/messages', to: 'messages#send_message'
    get 'chatrooms', to: 'chatrooms#index'
    get 'chatrooms/:id', to: 'chatrooms#all_messages'
    get 'chatrooms/:id/messages', to: 'chatrooms#show' 
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end