Rails.application.routes.draw do
  resources :supports

  resources :blogs

  resources :albums

  devise_for :users

  resources :images do
    resources :comments
  end

  root to: "welcome#index"
  controller "welcome", as: "welcome" do
    get :index
    get :about_us
    get :privacy
    get :terms
    get :blog
    get :support
  end
end
