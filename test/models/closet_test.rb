# == Schema Information
#
# Table name: closets
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  title      :string(255)
#  summary    :text
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class ClosetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
