# == Route Map
#
#                            Prefix Verb     URI Pattern                            Controller#Action
#                  new_user_session GET      /users/sign_in(.:format)               devise/sessions#new
#                      user_session POST     /users/sign_in(.:format)               devise/sessions#create
#              destroy_user_session DELETE   /users/sign_out(.:format)              devise/sessions#destroy
#           user_omniauth_authorize GET|POST /users/auth/:provider(.:format)        users/omniauth_callbacks#passthru {:provider=>/facebook/}
#            user_omniauth_callback GET|POST /users/auth/:action/callback(.:format) users/omniauth_callbacks#(?-mix:facebook)
#                     user_password POST     /users/password(.:format)              devise/passwords#create
#                 new_user_password GET      /users/password/new(.:format)          devise/passwords#new
#                edit_user_password GET      /users/password/edit(.:format)         devise/passwords#edit
#                                   PATCH    /users/password(.:format)              devise/passwords#update
#                                   PUT      /users/password(.:format)              devise/passwords#update
#          cancel_user_registration GET      /users/cancel(.:format)                registrations#cancel
#                 user_registration POST     /users(.:format)                       registrations#create
#             new_user_registration GET      /users/sign_up(.:format)               registrations#new
#            edit_user_registration GET      /users/edit(.:format)                  registrations#edit
#                                   PATCH    /users(.:format)                       registrations#update
#                                   PUT      /users(.:format)                       registrations#update
#                                   DELETE   /users(.:format)                       registrations#destroy
#                authenticated_root GET      /                                      items#index
#                              root GET      /                                      items#index
# update_user_facebook_confirmation GET      /users/facebook_confirmation(.:format) registrations#facebook_confirmation
#              update_password_user PATCH    /user/update_password(.:format)        users#update_password
#                         edit_user GET      /user/edit(.:format)                   users#edit
#                             users GET      /users(.:format)                       users#index
#                                   POST     /users(.:format)                       users#create
#                          new_user GET      /users/new(.:format)                   users#new
#                                   GET      /users/:id/edit(.:format)              users#edit
#                              user GET      /users/:id(.:format)                   users#show
#                                   PATCH    /users/:id(.:format)                   users#update
#                                   PUT      /users/:id(.:format)                   users#update
#                                   DELETE   /users/:id(.:format)                   users#destroy
#               edit_multiple_items GET      /items/edit_multiple(.:format)         items_management#edit_multiple
#             update_multiple_items PUT      /items/update_multiple(.:format)       items_management#update_multiple
#                             items GET      /items(.:format)                       items#index
#                                   POST     /items(.:format)                       items#create
#                          new_item GET      /items/new(.:format)                   items#new
#                         edit_item GET      /items/:id/edit(.:format)              items#edit
#                              item GET      /items/:id(.:format)                   items#show
#                                   PATCH    /items/:id(.:format)                   items#update
#                                   PUT      /items/:id(.:format)                   items#update
#                                   DELETE   /items/:id(.:format)                   items#destroy
#                             likes GET      /likes(.:format)                       likes#index
#                                   POST     /likes(.:format)                       likes#create
#                          new_like GET      /likes/new(.:format)                   likes#new
#                         edit_like GET      /likes/:id/edit(.:format)              likes#edit
#                              like GET      /likes/:id(.:format)                   likes#show
#                                   PATCH    /likes/:id(.:format)                   likes#update
#                                   PUT      /likes/:id(.:format)                   likes#update
#                                   DELETE   /likes/:id(.:format)                   likes#destroy
#                           closets GET      /closets(.:format)                     closets#index
#                                   POST     /closets(.:format)                     closets#create
#                        new_closet GET      /closets/new(.:format)                 closets#new
#                       edit_closet GET      /closets/:id/edit(.:format)            closets#edit
#                            closet GET      /closets/:id(.:format)                 closets#show
#                                   PATCH    /closets/:id(.:format)                 closets#update
#                                   PUT      /closets/:id(.:format)                 closets#update
#                                   DELETE   /closets/:id(.:format)                 closets#destroy
#                     closets_items POST     /closets_items(.:format)               closets_items#create
#                      closets_item DELETE   /closets_items/:id(.:format)           closets_items#destroy
#                   item_management GET|POST /item_management(.:format)             items_management#index
#

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

  # for update password
  resource :user, only: [:edit] do
    collection do
      patch 'update_password'
    end
  end

  resources :users
  resources :items do
    collection do
      get :edit_multiple, controller: 'items_management'
      put :update_multiple, controller: 'items_management'
    end
  end
  resources :likes
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



end
