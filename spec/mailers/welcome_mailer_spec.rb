require "rails_helper"

RSpec.describe WelcomeMailer, :type => :mailer do

  def clear_sent_email
    ActionMailer::Base.deliveries = []
  end

  def sent_mail
    ActionMailer::Base.deliveries
  end


  let(:user) { FactoryGirl.create(:user) }


  describe "welcome_email" do
    before do
      clear_sent_email
      WelcomeMailer.welcome_email(user.id).deliver
    end

    it "sends to right user" do
      expect(sent_mail.last.to).to eq([user.email])
    end

    it "only sends one" do
      expect(sent_mail.count).to eq(1)
    end

    it "matches expected view" do
      expect(sent_mail.last.body).to include("Welcome to Showspace.")
    end
  end



end
