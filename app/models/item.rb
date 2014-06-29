class Item < ActiveRecord::Base

	has_and_belongs_to_many :closets
	has_many :users, through: :closets
	has_many :likes, as: :likeable

	serialize :image_source_array

  # For the money-rails gem
  monetize :price_cents, :allow_nil => true
  monetize :price_cents, with_model_currency: :currency


end
