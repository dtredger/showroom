ActiveAdmin.register User do

  actions :all, except: [:edit, :update]

  permit_params :remember_created_at,
    :sign_in_count,
    :current_sign_in_at,
    :last_sign_in_at,
    :current_sign_in_ip,
    :last_sign_in_ip,
    :created_at,
    :updated_at,
    :fb_uid,
    :fb_token,
    :fb_token_expiration,
    :username,
    :email,
    :password

  # created within last 72 hours
  # scope("New Users")  { |scope| scope.where((((Time.now.utc - created_at.utc)/1000)/60)/60) < 72 }

  # filter :items, as: :select, collection: lambda { Item.all }

  index do
    selectable_column
    id_column
    column :username
    column :email
    column :closets, lambda { |u| u.closets.count }
    column :total_items_saved, lambda { |u| u.items.count }
    column :created_at
    column :updated_at
    column :current_sign_in_at
    column :current_sign_in_ip
    column :sign_in_count
    column :fb_token_expiration
  end

  show do
    attributes_table do
      row :username
      row :email
      row :created_at
      row :updated_at
      row :current_sign_in_at
      row :current_sign_in_ip
      row :sign_in_count
      row :fb_token_expiration
    end
  end


  form do |f|
    f.inputs "New User" do
      f.input :username
      f.input :email
      f.input :password
    end
    f.actions
  end


end
