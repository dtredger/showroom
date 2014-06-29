Showspace::Application.routes.draw do
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", registrations: 'registrations' }

  # routes for authenticated users
  authenticated :user do
    root to: 'items#index', as: :authenticated_root
  end

  # routes for non-authenticated users
  devise_scope :user do
    root to: 'items#index'
    # handles Facebook confirmation signup
    match '/users/facebook_confirmation' => 'registrations#facebook_confirmation', :via => :get, :as => :update_user_facebook_confirmation
  end

  resources :items
  resources :likes
  resources :closets
  resources :closets_items, only: [:create, :destroy]

end
