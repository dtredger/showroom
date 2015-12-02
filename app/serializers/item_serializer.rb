class ItemSerializer < ActiveModel::Serializer
  attributes :id, :product_name,
    :description,
    :designer,
    :price_cents,
    :currency,
    :store_name,
    :product_link,
    :category1,
    :category2,
    :category3,
    :state,
    :created_at,
    :updated_at,
    :sku,
    :slug
end
