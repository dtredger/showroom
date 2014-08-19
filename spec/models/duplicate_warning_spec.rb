# == Schema Information
#
# Table name: duplicate_warnings
#
#  id               :integer          not null, primary key
#  pending_item_id  :integer
#  existing_item_id :integer
#  warning_notes    :text
#  created_at       :datetime
#  updated_at       :datetime
#  match_score      :integer
#

require 'rails_helper'

RSpec.describe DuplicateWarning, :type => :model do
  pending "creation of a duplicate_warning is handled in the item_spec"
end
