ActiveAdmin.register DuplicateWarning do

  menu priority: 8
  menu parent: 'Items'

  permit_params :pending_item_id, :existing_item_id, :match_score, :warning_notes


  index do
    selectable_column
    id_column
    column :pending_item_id
    column :existing_item_id
    column :warning_notes
    column :match_score
    column :created_at
    column :updated_at
  end

  index as: :grid, columns: 2 do |item|
    link_to image_tag(item.image_source), admin_item_path(item)
  end

  #
  # form do |f|
  #   # f.input :pending_item_id, as: :select, collection:
  # #   f.input :existing_item_id
  # end

  # controller do
  #   show do
  #
  #   end
  # end



end
