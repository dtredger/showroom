require "rails_helper"

RSpec.describe WelcomeMailer, :type => :mailer do

  def last_email
    ActionMailer::Base.deliveries.last
  end

  def clear_sent_email
    ActionMailer::Base.deliveries = []
  end


  before(:all) do
    User.delete_all
    @user = create(:user)
  end



  describe "welcome_email" do
    before do
      clear_sent_email
      WelcomeMailer.welcome_email(@user.id).deliver
    end

    it "sends to right user" do
      expect(ActionMailer::Base.deliveries.last.to).to eq([@user.email])
    end

    it "only sends one" do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end





end
