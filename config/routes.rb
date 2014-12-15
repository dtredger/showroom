Showspace::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)

  devise_for :users, skip: [:sessions], controllers: {
      omniauth_callbacks: "users/omniauth_callbacks",
      registrations:      "users/registrations"
  }

  # Devise adds the following (doesn't show up in Rake Routes / Rubymine)
  #   new_session_path(:user)      => new_user_session_path
  #   session_path(:user)          => user_session_path
  #   destroy_session_path(:user)  => destroy_user_session_path
  #
  #   new_password_path(:user)     => new_user_password_path
  #   password_path(:user)         => user_password_path
  #   edit_password_path(:user)    => edit_user_password_path
  #
  #   new_confirmation_path(:user) => new_user_confirmation_path
  #   confirmation_path(:user)     => user_confirmation_path


  # routes for authenticated users
  authenticated :user do
    root to: 'items#index', as: :authenticated_root
  end

  # routes for non-authenticated users
  devise_scope :user do
    root to: 'items#index'

    get 'signin' =>     'devise/sessions#new',      as: :new_user_session
    post 'signin' =>    'devise/sessions#create',   as: :user_session
    delete 'signout' => 'devise/sessions#destroy',  as: :destroy_user_session

    # handles Facebook confirmation signup
    match '/users/facebook_confirmation' => 'users/registrations#facebook_confirmation',
      via: :get,
      as: :update_user_facebook_confirmation
  end

  get 'profile', to: 'users#show'
  get 'users/edit_password', to: 'users#edit_password'
  patch 'users/update_password', to: 'users#update_password'

  resources :items, only: [:index, :show] do
    collection do
      get :edit_multiple, controller: 'items_management'
      put :update_multiple, controller: 'items_management'
    end
  end

  # resources :likes  #not implemented

  resources :closets

  resources :closets_items, only: [:create, :destroy]

  #resources :duplicate_warnings

  match 'item_management', to: 'items_management#index', via: [:get, :post]

  # resources :items_managements do
  #   collection do
  #     get :edit_multiple
  #     put :update_multiple
  #   end
  # end

  get '*path' => redirect('/')  unless Rails.env.development?


end
