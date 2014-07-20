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

  after_create :check_for_duplicate


  #
  # Also pass in warning text and identical? boolean
  #
  def add_duplicate_warning!(other_item, warning_notes)
    self.duplicate_warnings.create!(existing_item_id: other_item.id, warning_notes: warning_notes)
  end

  def remove_duplicate_warning!(other_item)
    self.duplicate_warnings.find_by(existing_item_id: other_item.id).destroy
  end

  #
  # Refactor SQL query & memory management
  #
  def check_for_duplicate
    if self.store_name
      check_items = Item.where(store_name: self.store_name).where.not(id: self.id)
      check_items.each do |check_item|
        if self.designer == check_item.designer && self.product_name == check_item.product_name
          self.add_duplicate_warning!(check_item, "match: designer & product_name")
        end
      end
    end
  end

end