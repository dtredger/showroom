# == Schema Information
#
# Table name: likes
#
#  id            :integer          not null, primary key
#  likeable_id   :integer
#  likeable_type :string(255)
#  user_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'rails_helper'

RSpec.describe Like, :type => :model do

  context "model" do
    it { is_expected.to respond_to(:likeable_id) }
    it { is_expected.to respond_to(:likeable_type) }
  end

  context "user" do
    describe "" do
      Like.
    end
  end

end
