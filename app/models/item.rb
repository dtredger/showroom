# == Schema Information
#
# Table name: items
#
#  id                 :integer          not null, primary key
#  product_name       :text
#  description        :text
#  designer           :text
#  price_cents        :integer
#  currency           :string(255)
#  store_name         :string(255)
#  image_source       :text
#  image_source_array :text
#  product_link       :text
#  category1          :string(255)
#  category2          :string(255)
#  category3          :string(255)
#  state              :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class Item < ActiveRecord::Base

  has_and_belongs_to_many :closets
  has_many :users, through: :closets
	has_many :likes, as: :likeable, dependent: :destroy
  has_many :matches, through: :duplicate_warnings, source: :existing_item
  has_many :duplicate_warnings, foreign_key: "pending_item_id", dependent: :destroy

	serialize :image_source_array

  # For the money-rails gem
  monetize :price_cents, :allow_nil => true
  monetize :price_cents, with_model_currency: :currency

  default_scope -> { order('created_at DESC') }
  scope :search_min_price, -> (min_price) { where("price_cents >= ?", min_price) }
  scope :search_max_price, -> (max_price) { where("price_cents <= ?", max_price) }
  scope :search_designer, -> (designer) { where("designer LIKE ?", "#{designer}%") }
  scope :search_category1, -> (category1) { where("category1 LIKE ?", "#{category1}%") }

  mount_uploader : image_source, ItemImageUploader

  after_create :check_for_duplicate
  before_destroy :delete_associated_images

  def add_duplicate_warning!(other_item, match_score, warning_notes)
    self.duplicate_warnings.create!(existing_item_id: other_item.id, match_score: match_score, warning_notes: warning_notes)
  end

  def remove_duplicate_warning!(other_item)
    self.duplicate_warnings.find_by(existing_item_id: other_item.id).destroy
  end

  def delete_associated_images
    path_to_image = 'public' + self.image_source
    File.delete(path_to_image) if File.exist?(path_to_image)
  end

  def check_for_duplicate
    if self.store_name
      check_items = Item.where(store_name: self.store_name).where.not(id: self.id)
      check_items.each do |check_item|
        if self.designer == check_item.designer && self.product_name == check_item.product_name
          self.add_duplicate_warning!(check_item, 0, "match: designer & product_name")
        end
      end
    end
  end

end
