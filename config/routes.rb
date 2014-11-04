Rails.application.routes.draw do

  namespace :admin do
    get "", to: "dashboard#index", as: "/"
    resources :albums
  end

  resources :supports, :blogs

  devise_for :users, controllers: { sessions: "users/sessions" }

  resources :albums, as: :cards, path: :cards do
    collection do
      get :hidden_cards
    end

    member do
      post :hide_card
      post :view_card
    end

    resources :photos do
      member do
        get :like
      end
      resources :comments
    end
  end

  resources :users do
    get :profile
    member do
      patch :update_account_settings
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
