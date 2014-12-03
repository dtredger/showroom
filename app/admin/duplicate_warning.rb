ActiveAdmin.register DuplicateWarning do

  menu priority: 8
  menu parent: 'Items'

  permit_params :pending_item_id, :existing_item_id, :match_score, :warning_notes

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
