Showspace::Application.routes.draw do
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", registrations: 'registrations' }

  # routes for authenticated users
  authenticated :user do
    root to: 'users#landing_page', as: :authenticated_root
  end

  # routes for non-authenticated users
  devise_scope :user do
    #root to: 'users#landing_page'
    root to: 'items#index'
  end

  resources :items

end
