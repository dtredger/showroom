# == Schema Information
#
# Table name: admin_users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

require 'rails_helper'

RSpec.describe AdminUser, :type => :model do

  let!(:admin_user) { create(:admin_user) }

  context "model" do
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:password) }
    it { is_expected.to respond_to(:encrypted_password) }
  end

  describe "validations" do
    context "email" do
      it "rejects duplicates" do
        duplicate = AdminUser.new(email: admin_user.email, password: "10521b92")
        expect(duplicate).to have(1).errors_on(:email)
      end
    end

    context "password" do
      it "rejects < 4 characters" do
        duplicate = AdminUser.new(email: "something_new@email.co", password: "123")
        expect(duplicate).to have(1).errors_on(:password)
      end
    end
  end


end
