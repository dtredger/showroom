# ActiveAdmin.register DuplicateWarning do
#
#   menu priority: 8
#   menu parent: 'Items'
#
#   permit_params :pending_item_id, :existing_item_id, :match_score, :warning_notes
#
#   scope("Identical Match")  { |scope| scope.where(match_score: 330..9999) }
#
#   filter :pending_item, collection: Item.joins(:duplicate_warnings).collect { |i| "#{i.designer} - #{i.product_name} - $#{i.price_cents}" }
#   filter :warning_notes
#   filter :created_at
#   filter :updated_at
#   filter :match_score
#
#   index do
#     selectable_column
#     id_column
#     column :pending_item_id
#     column :existing_item_id
#     column :match_score
#     column :warning_notes
#     column :created_at
#     column :updated_at
#     actions
#   end
#
#   index as: :grid, columns: 3 do |warning|
#     pending = Item.find(warning.pending_item_id)
#     existing = Item.find(warning.existing_item_id)
#     ul.add_class "cats"
#       li link_to image_tag(pending.images[0].source, size:"56x80"), admin_item_path(pending)
#       li pending.designer
#       li pending.product_name
#       li pending.store_name
#       br
#       li link_to image_tag(existing.images[0].source, size:"56x80"), admin_item_path(existing)
#       li existing.designer
#       li existing.product_name
#       li existing.store_name
#   end
#
#
#   batch_action :delete_all_pending_items, priority: 1, confirm: "Delete Pending items?" do |ids|
#     DuplicateWarning.find(ids).each do |warning|
#       Item.find(warning.pending_item_id).delete
#       DuplicateWarning.find(warning).delete
#     end
#     redirect_to admin_duplicate_warnings_path, alert: "All selected pending items were deleted."
#   end
#
#   batch_action :delete_all_existing_items, priority: 2, confirm: "Delete Existing items?" do |ids|
#     DuplicateWarning.find(ids).each do |warning|
#       Item.find(warning.existing_item_id).delete
#       DuplicateWarning.find(warning).delete
#     end
#     redirect_to admin_duplicate_warnings_path, alert: "All selected existing items were deleted."
#   end
#
#
#   # form do |f|
#   #   # f.input :pending_item_id, as: :select, collection:
#   # #   f.input :existing_item_id
#   # end
#
#   # controller do
#   #   show do
#   #
#   #   end
#   # end
#
#
#
# end
