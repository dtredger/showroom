require 'rails_helper'

RSpec.describe OmniauthCallbacksController, :type => :controller do

  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end



end
