require "rails_helper"

RSpec.describe UserMailer, :type => :mailer do

  let(:user) { create(:user) }
  let(:email) { UserMailer.new_user(user) }

  describe "#new_user" do
    it "sends to user email" do

    end

    it "contains greeting" do

    end

    it "contains link to account" do

    end
  end


end
