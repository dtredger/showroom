require 'rails_helper'

# ---------------- the following routes are built into devise, therefore untested here --------------------
#
#  # Session routes for Authenticatable (default)
#       new_user_session GET    /users/sign_in                    {controller:"devise/sessions", action:"new"}
#           user_session POST   /users/sign_in                    {controller:"devise/sessions", action:"create"}
#   destroy_user_session DELETE /users/sign_out                   {controller:"devise/sessions", action:"destroy"}
#
#  # Password routes for Recoverable, if User model has :recoverable configured
#      new_user_password GET    /users/password/new(.:format)     {controller:"devise/passwords", action:"new"}
#     edit_user_password GET    /users/password/edit(.:format)    {controller:"devise/passwords", action:"edit"}
#          user_password PUT    /users/password(.:format)         {controller:"devise/passwords", action:"update"}
#                        POST   /users/password(.:format)         {controller:"devise/passwords", action:"create"}
#
#
# --------------------------------------------------------------------------------------------------------

RSpec.describe RegistrationsController, :type => :controller do
  # tell Devise which mapping should be used before a request. This is necessary because Devise
  # gets this information from the router, but since functional tests do not pass through the router,
  # it needs to be told explicitly. For example, if you are testing the user scope, simply do:
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  # controller do
  #   def after_sign_up_path_for(resource)
  #     super resource
  #   end
  # end

  describe "User sign_up" do

    it "change current_user" do
      post :create, user: FactoryGirl.attributes_for(:user)
      expect( subject.current_user ).not_to be nil
    end
  end


end
