require 'rails_helper'

RSpec.describe ProductCheckJob, type: :job do

  let!(:item1) { FactoryGirl.create(:unique_item, state: "live", product_link: "http://google.ca/") }
  let!(:item2) { FactoryGirl.create(:unique_item, state: "retired") }
  let!(:item3) { FactoryGirl.create(:unique_item, state: "live", product_link: "") }
  let!(:item4) { FactoryGirl.create(:unique_item, state: "live", product_link: "nope!") }


  it "only checks live items" do
    expect{
      ProductCheckJob.new.perform
    }.not_to change{item2.updated_at}
  end

  it "returns error list" do
    response = ProductCheckJob.new.perform
    expect(response).to be_a(Array)
  end

  describe "good URL" do
    # TODO requires internet
    it "changes updated_at" do
      initial_time = item1.updated_at
      ProductCheckJob.new.perform

      expect(item1.updated_at).not_to eq(initial_time)
    end

    it "does not change state" do
      ProductCheckJob.new.perform
      item1.reload
      expect(item1.state).to eq("live")
    end
  end

  describe "bad URL" do
    it "retires items" do
      ProductCheckJob.new.perform
      item3.reload
      item4.reload
      expect(item3.state).to eq("retired")
      expect(item4.state).to eq("retired")
    end
  end

end

