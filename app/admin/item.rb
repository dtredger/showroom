ActiveAdmin.register Item do

  actions :all, except: [:new, :create]
  menu priority: 4

  permit_params :product_name,
    :designer,
    :price_cents,
    :currency,
    :store_name,
    :product_link,
    :category1,
    :category2,
    :category3,
    :state

  scope("Pending")  { |scope| scope.where(state: 0) }
  scope("Live")     { |scope| scope.where(state: 1) }
  scope("Retired")  { |scope| scope.where(state: 2) }
  scope("Banned")   { |scope| scope.where(state: 3) }
  scope("Deleted")  { |scope| scope.where(state: 4) }

  filter :product_name
  filter :designer, as: :select
  filter :price_cents
  filter :currency, as: :select
  filter :store_name, as: :select
  filter :category1
  filter :category2
  filter :category3


  index do
    selectable_column
    id_column
    column :product_name
    column :designer
    column :price_cents
    column :currency
    column :store_name
    column :product_link
    column :category1
    column :category2
    column :category3
    column :state
    actions
  end

  index as: :grid, columns: 4 do |item|
    link_to image_tag(item.images[0].source, size:"102x160"), admin_item_path(item)
  end


  action_item :view, only: :show do
    link_to 'View on site', item_path(item)
  end

  show do
    attributes_table do
      row :product_name
      row :designer
      row :price_cents
      row :currency
      row :store_name
      row :category1
      row :category2
      row :category3
      row :state
    end
  end


  # form do |f|
  #   f.inputs "New Item" do
  #     f.input :product_name, as: :string
  #     f.input :description, as: :string
  #     f.input :designer, as: :string
  #     f.input :price_cents
  #     f.input :currency
  #     f.input :store_name, as: :string
  #     # f.input :image, # requires nested attributes? this form seems unimportant for now
  #     f.input :product_link, as: :string
  #     f.input :category1
  #     f.input :category2
  #     f.input :category3
  #     f.input :state, as: :select, collection: [1,2,3,4,5]
  #   end
  #   f.actions
  # end


  batch_action :set_live, priority: 1, confirm: "Set selected items live?" do |ids|
    Item.find(ids).each do |item|
      item.update(state: 1)
    end
    redirect_to admin_items_path, notice: "All selected items were set live."
  end

  batch_action :retire, priority: 2, confirm: "Retire selected items?" do |ids|
    Item.find(ids).each do |item|
      item.update(state: 2)
    end
    redirect_to admin_items_path, notice: "All selected items were retired."
  end


  controller do

    def scoped_collection
      super.includes :duplicate_warnings
    end

  end

end
