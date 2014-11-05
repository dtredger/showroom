ActiveAdmin.register Item do


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

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

  filter :product_name
  filter :designer
  filter :price_cents
  filter :currency
  filter :store_name
  filter :image_source
  filter :product_link
  filter :category1
  filter :category2
  filter :category3
  filter :state

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

end
