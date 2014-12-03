ActiveAdmin.register Item do

  menu priority: 4

  permit_params :product_name,
    :designer,
    :price_cents,
    :currency,
    :store_name,
    :image_source,
    :image_source_array,
    :product_link,
    :category1,
    :category2,
    :category3,
    :state


  index do
    selectable_column
    id_column
    column :product_name
    column :designer
    column :price_cents
    column :currency
    column :store_name
    column :image_source
    column :product_link
    column :category1
    column :category2
    column :category3
    column :state
    actions
  end

  index as: :grid, columns: 2 do |item|
    link_to image_tag(item.image_source), admin_item_path(item)
  end

  filter :product_name
  filter :designer, as: :select
  filter :price_cents
  filter :currency, as: :select
  filter :store_name, as: :select
  filter :category1
  filter :category2
  filter :category3
  filter :state, as: :select

  action_item :view, only: :show do
    link_to 'View on site', post_path(post) if post.published?
  end

  show do
    image_tag(item.image_source)
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


  form do |f|
    f.inputs "New Item" do
      f.input :product_name
      f.input :description
      f.input :designer
      f.input :price_cents
      f.input :currency
      f.input :store_name
      f.input :image_source
      f.input :image_source_array
      f.input :product_link
      f.input :category1
      f.input :category2
      f.input :category3
      f.input :state
    end
    f.actions
  end

  controller do

    def scoped_collection
      super.includes :duplicate_warnings
    end

  end

end
