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

require 'test_helper'

class DuplicateWarningTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
