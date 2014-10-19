Showspace::Application.routes.draw do

  devise_for :users, skip: [:sessions], controllers: {
      omniauth_callbacks: "users/omniauth_callbacks",
      registrations: 'users/registrations'
  }


  # routes for authenticated users
  authenticated :user do
    root to: 'items#index', as: :authenticated_root
  end

  # routes for non-authenticated users
  devise_scope :user do
    root to: 'items#index'

    get 'signin' => 'devise/sessions#new', :as => :new_user_session
    post 'signin' => 'devise/sessions#create', :as => :user_session
    delete 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session

    # handles Facebook confirmation signup
    match '/users/facebook_confirmation' => 'users/registrations#facebook_confirmation',
      via: :get,
      as: :update_user_facebook_confirmation
  end


  # TODO will we want to give users access to others' profiles in the future?
  # resources :users, only: [:show]

  get 'profile', to: 'users#show'
  # for update password
  resource :user, only: [:edit] do
    collection do
      patch 'update_password'
    end
  end

  resources :items do
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
