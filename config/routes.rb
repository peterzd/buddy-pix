Rails.application.routes.draw do

  mount API::Root => '/'

  namespace :admin do
    get "", to: "dashboard#index", as: "/"
    resources :albums do
      member do
        get :hide_card
        get :view_card
      end
    end

    resources :users
  end

  resources :supports, :blogs

  devise_for :users, controllers: { sessions: "users/sessions" }

  resources :albums, as: :cards, path: :cards do
    post :invite_by_email, to: "invitations#invite_by_email"
    resources :invitations
    collection do
      get :hidden_cards
      get :following_cards
    end

    member do
      post :hide_card
      post :publish_card
      get :follow
      get :unfollow
    end

    resources :photos do
      member do
        get :like
        get :download
      end
      resources :comments
    end
  end

  post "comments/:id/reply", to: "comments#reply", as: :reply_comment

  get :my_wall, to: "users#my_wall"
  resources :users do
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

  get "search", to: "search#search", as: :search
  # get "search_cards", to: "search#search_cards", as: :search_cards


end
