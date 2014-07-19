class Item < ActiveRecord::Base

  has_and_belongs_to_many :closets
  has_many :users, through: :closets
	has_many :likes, as: :likeable

	#after_create :check_for_duplicate

	serialize :image_source_array

  # For the money-rails gem
  monetize :price_cents, :allow_nil => true
  monetize :price_cents, with_model_currency: :currency

  default_scope -> { order('created_at DESC') }
  scope :search_min_price, -> (min_price) { where("price_cents >= ?", min_price) }
  scope :search_max_price, -> (max_price) { where("price_cents <= ?", max_price) }
  scope :search_designer, -> (designer) { where("designer LIKE ?", "#{designer}%") }
  scope :search_category1, -> (category1) { where("category1 LIKE ?", "#{category1}%") }

  # def check_for_duplicate
  # 	# Psuedo code

  # 	# get items from the same store
  # 	Items.each do |check_item|
  		
  # 		# check for name match
  # 		if self.designer == check_item.designer && self.product_name == check_item.product_name
  # 			# create warning of name match
  # 		end

  # 		# check for image match
  # 		# create image_hash_checksum on Item model
  # 		if self.image_hash_checksum == check_item.image_hash_checksum
  # 			# create warning of image match
  # 		end

  # 		# check for link match
  # 		if self.product_link == check_item.product_link
  # 			# create warning of link match
  # 		end

  # 		#
  # 		# If match > 2/3 => create notice of identical item
  # 		# Otherwise create notice of potential match
  # 		#

  # 	end
  # end

end