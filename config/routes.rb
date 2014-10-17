Rails.application.routes.draw do
  resources :albums

  devise_for :users
  root to: "home#index"

end
