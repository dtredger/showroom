ActiveAdmin.register User do

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
    :username


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

end
