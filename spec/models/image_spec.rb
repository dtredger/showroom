# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  image      :string(255)
#  item_id    :integer
#

require 'rails_helper'

RSpec.describe Image, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

#
# context "images" do
#   describe "image_source" do
#     it "names image with filename" do
#       expect(item_1["image_source"]).to eq("doge_log.gif")
#     end
#
#     it "formats path with attributes" do
#       expect(item_1.image_source.url).to eq("/items/a_store_na/designer_test/Test_Produ/doge_log.gif")
#     end
#
#     it "stores CarrierWave file" do
#       expect(item_1.image_source.file.class.to_s).to eq("CarrierWave::SanitizedFile")
#     end
#   end
# end
