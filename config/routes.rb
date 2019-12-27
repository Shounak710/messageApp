Rails.application.routes.draw do
  namespace :api do
    resources :users
    post 'auth/register', to: 'users#register'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end