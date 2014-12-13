# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  source     :string(255)
#  item_id    :integer
#

require 'rails_helper'

RSpec.describe Image, :type => :model do

  sample_image = "#{Rails.root}/public/images/doge_log.gif"

  let(:user) { FactoryGirl.create(:user) }
  let(:user_2) { FactoryGirl.create(:user_2) }

  let(:item) { FactoryGirl.create(:item) }


  describe "validations" do
    context "source" do
      it "rejects blank" do
        blank = item.images.build(source: nil)
        expect(blank).to have(1).errors_on(:source)
      end

      it "errors on paths" do
        expect{
          item.images.build(source: sample_image)
        }.to raise_error(CarrierWave::FormNotMultipart)
      end

      it "accepts files" do
        file = item.images.build(source:open(sample_image))
        expect(file).to be_valid
      end
    end

    context "item" do
      it "rejects for invalid item" do
        invalid_item = FactoryGirl.build(:image,
            source: open(sample_image),
            item_id: 0)
        expect(invalid_item).not_to be_valid
      end

      it "accepts for valid item" do
        valid_item = FactoryGirl.build(:image,
            source: open(sample_image),
            item_id: item.id)
        expect(valid_item).to be_valid
      end
    end
  end

end
