require 'rails_helper'

RSpec.describe ItemImageUploader, :type => :uploader do

  context '#store_dir' do

    it 'sets correct storage path' do
      item = FactoryGirl.create(Item,
        store_name: "name!",
        designer: "designer?",
        product_name: "name & more")
      uploader = ItemImageUploader.new(model=item)

      expect(uploader.store_dir).to eq("items/name_/designer_/name___mor")
    end
  end

end
