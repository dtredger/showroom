ActiveAdmin.register DuplicateWarning do

  menu priority: 8
  menu parent: 'Items'

  permit_params :pending_item_id, :existing_item_id, :match_score, :warning_notes


  # index as: :grid, columns: 1 do |warning|
  #   pending = Item.find(warning.pending_item_id)
  #   existing = Item.find(warning.existing_item_id)
  #   link_to image_tag(pending.image_source), admin_item_path(pending)
  #   pending.product_name
  #   link_to image_tag(existing.image_source), admin_item_path(existing)
  #   existing.product_name
  # end


  batch_action :delete_all_pending_items, priority: 1, confirm: "Delete Pending items?" do |ids|
    DuplicateWarning.find(ids).each do |warning|
      Item.find(warning.pending_item_id).delete
      DuplicateWarning.find(warning).delete
    end
    redirect_to admin_duplicate_warnings_path, alert: "All selected pending items were deleted."
  end

  batch_action :delete_all_existing_items, priority: 2, confirm: "Delete Existing items?" do |ids|
    DuplicateWarning.find(ids).each do |warning|
      Item.find(warning.existing_item_id).delete
      DuplicateWarning.find(warning).delete
    end
    redirect_to admin_duplicate_warnings_path, alert: "All selected existing items were deleted."
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
