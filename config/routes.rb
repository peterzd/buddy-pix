Rails.application.routes.draw do
  resources :supports, :blogs, :albums

  devise_for :users, controllers: { sessions: "users/sessions" }

  resources :images do
    resources :comments
  end

  resources :users do
    member do
      post :update_account_settings
    end

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

  scope "dashboard" do
    controller :dashboard, as: "dashboard" do
      get :account_settings
    end
  end
end
