Showspace::Application.routes.draw do
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", registrations: 'registrations' }

  authenticated :user do
    root to: 'users#landing_page', as: :authenticated_root
  end

  devise_scope :user do
    root to: 'users#landing_page'
  end

end
