# == Schema Information
#
# Table name: items
#
#  id           :integer          not null, primary key
#  product_name :text
#  description  :text
#  designer     :text
#  price_cents  :integer
#  currency     :string(255)
#  store_name   :string(255)
#  product_link :text
#  category1    :string(255)
#  category2    :string(255)
#  category3    :string(255)
#  state        :integer
#  created_at   :datetime
#  updated_at   :datetime
#  sku          :string(255)
#

class Item < ActiveRecord::Base

  has_and_belongs_to_many :closets
  has_many :users, through: :closets
	has_many :likes, as: :likeable, dependent: :destroy
  has_many :matches, through: :duplicate_warnings, source: :existing_item
  has_many :duplicate_warnings, foreign_key: "pending_item_id"
  # TODO does not allow bidirectional foreign_key, if uncommented will override above
  # has_many :duplicate_warnings, foreign_key: "existing_item_id"
  # TODO image files should be removed from s3: if they're just deleted, we lose
  # any way of finding them (calling destroy on image alone does remove...)
  has_many :images, dependent: :destroy


  # Virtual attribute
  attr_accessor :old_item_update

  # For the money-rails gem
  monetize :price_cents, :allow_nil => true
  monetize :price_cents, with_model_currency: :currency

  default_scope -> { order('created_at DESC') }
  scope :search_min_price, -> (min_price) { where("price_cents >= ?", min_price) }
  scope :search_max_price, -> (max_price) { where("price_cents <= ?", max_price) }
  scope :search_designer, -> (designer) { where("designer LIKE ?", "#{designer}%") }
  scope :search_category1, -> (category1) { where("category1 LIKE ?", "#{category1}%") }


  # TODO - "In Rails 4.1 delete_all on associations would not fire callbacks. It means if the
  # :dependent option is :destroy then the associated records would be deleted without loading and invoking callbacks."
  after_create :check_for_duplicate
  after_save :perform_item_management_operation, :handle_state
  after_destroy :delete_duplicate_warnings

  # either delete doesn't work properly or problem with image transfer?
  def perform_item_management_operation
    if old_item_update.present?

      # update the older item with the attributes of the newer item (duplicate)
      other_item = Item.find(old_item_update)
      other_item_image_path = 'public' + other_item.image_source


      # http://stackoverflow.com/questions/10112946/nice-way-to-merge-copy-attributes-between-two-activerecord-classes
      # no :without_protection => true in rails 4 for assign?
      # http://stackoverflow.com/questions/6770350/rails-update-attributes-without-save
      # update_attributes = assign_attributes + save
      # SIMPLY UPDATE EACH ATTRIBUTE DIRECTLY
      # a.attrib = b.attrib
      # a.save
      forbidden_attributes = ["id", "state", "created_at", "category1", "category2", "category3", "image_source"]

      self.attributes.select do |attrib, val|
        if !forbidden_attributes.include?(attrib) && Item.column_names.include?(attrib)
          # http://www.davidverhasselt.com/set-attributes-in-activerecord/
          other_item.update_attribute(attrib, val)
        end
      end


      # copy the image too
      newer_item_image_path = 'public' + self.image_source
      FileUtils.move newer_item_image_path, other_item_image_path if File.exist?(newer_item_image_path)
      self.destroy
    end
  end

  def handle_state
    self.destroy if state == 4
  end

  # TODO - delete warning once one of matches is deleted
  # deletes matches where item is existing or pending item
  def delete_duplicate_warnings
    if self.duplicate_warnings.any?
      warnings = self.duplicate_warnings
      if self.duplicate_warnings.respond_to? :each
        warnings.each { |warn| warn.destroy }
      else !warnings.nil?
        warnings.destroy
      end
    end
    warnings = DuplicateWarning.find_by(existing_item_id: self.id)
    if warnings.respond_to? :each
      warnings.each { |warn| warn.destroy }
    elsif !warnings.nil?
      warnings.destroy
    end
  end

  def check_for_duplicate
    if self.store_name
      check_items = Item.where(store_name: self.store_name).where.not(id: self.id)
      score = 0
      notes = ""
      check_items.each do |check_item|
        if self.sku == check_item.sku
          score += 100
          notes += "sku, "
        end
        if self.product_link == check_item.product_link
          score += 90
          notes += "product_link, "
        end
        if self.product_name == check_item.product_name
          score += 70
          notes += "product_name, "
        end
        if self.price_cents == check_item.price_cents
          score += 35
          notes += "price, "
        end
        if self.designer == check_item.designer
          score += 20
          notes += "designer, "
        end
        if self.category1 == check_item.category1
          score += 15
          notes += "category, "
        end
        if score >= 70
          notes = notes[0..-3] if notes.last(2) == ", "
          self.duplicate_warnings.create(existing_item_id: check_item.id,
              match_score: score,
              warning_notes: notes)
        end
      end
    end
  end

end
