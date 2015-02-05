require "rails_helper"

RSpec.describe AdminMailer, :type => :mailer do
  let(:admin_user) { create(:admin_user) }
  let(:email) { AdminMailer.new_user(user) }

  describe "#new_user" do
    it "sends to user email" do

    end

    it "contains greeting" do

    end

    it "contains link to account" do

    end
  end

end
