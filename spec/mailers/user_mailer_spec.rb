require "rails_helper"

RSpec.describe UserMailer, type: :mailer do

  let!(:user) { create(:user) }
  let!(:mail) { UserMailer.new_user(user) }

  describe "#new_user" do
    it "sends to user email" do
      expect(mail.to).to eq([user.email])
    end

    it "contains greeting" do
      expect(mail.body.encoded).to match "Hi #{user.username}"
    end

    it "contains link to account" do
      expect(mail.body.encoded).to match profile_path
    end
  end

end
