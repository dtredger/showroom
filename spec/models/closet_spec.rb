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

require 'rails_helper'

RSpec.describe Closet, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
