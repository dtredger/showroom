require "rails_helper"

RSpec.describe AdminMailer, type: :mailer do

  let(:admin_user) { create(:admin_user) }

  let(:job_message) { "index_scrape_job...ran at a time..." }
  let(:job_mail) { AdminMailer.jobs_notifier(admin_user, job_message) }

  let(:error_message) { "Error: something went wrong!" }
  let(:error_mail) { AdminMailer.error_notifier(admin_user, error_message) }


  describe "#jobs_notifier" do
    it "sends to admin email" do
      expect(job_mail.to).to eq([admin_user.email])
    end
  end

  describe "#error_notifier" do
    it "default send to user SMS" do
      pending("need phone# and carrier")
      expect(error_mail.to).to eq([admin_user.sms_gateway])
    end

    it "sends to user email if no SMS" do
      expect(error_mail.to).to eq([admin_user.email])
    end

    it "contains error message" do
      expect(error_mail.body.encoded).to match error_message
    end
  end

end
