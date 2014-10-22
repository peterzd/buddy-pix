Rails.application.routes.draw do
  resources :albums

  devise_for :users

  resources :images do
    resources :comments
  end

  root to: "welcome#index"
  controller "welcome" do
    get :index
    get :about_us
    get :terms
    get :blog
    get :support
  end
end
