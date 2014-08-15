require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  include Devise::TestHelpers

  before do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in FactoryGirl.create(:admin)
  end


  #
  # context "404" do
  #   before(:each) do
  #     get "/non_page"
  #   end
  #
  #   describe "for logged-in users" do
  #     it "redirects to show page" do
  #       pending
  #     end
  #   end
  #
  #   describe "for un-authenticated users" do
  #     it "redirects to index" do
  #       pending
  #       # response.should redirect_to :index
  #     end
  #
  #     it "shows flash error" do
  #       pending
  #       # flash[:notice].should eq("nope")
  #     end
  #   end
  # end


  # context "#index" do
  #   it "renders index template" do
  #     get :index
  #     response.should render_template :index
  #   end
  #
  #   it "responds with 200" do
  #     get :index
  #     response.status.should eq(200)
  #   end
  # end

  #

  context "#show" do
    describe "authenticated users" do
      before(:each) { @user = create(:default_user) }

      it "returns users#show" do
        get :show, id: @user.id
        assigns[:user].username.should eq("default_user@email.com")
        # response.should redirect_to user_path(@user)
      end

      it "returns welcome message" do
        pending
      end

    end

    describe "un-authenticated users" do

      it "stays on index for un-authenticated" do
        get :show, id: 121
        response.should redirect_to root_path
      end

      it "alerts un-authenticated to log in" do
        get :show, id: 121
        flash[:alert].should eq("please log in.")
      end
    end

  end

  #
  # context "#create" do
  #   describe "with bad attributes" do
  #     it "renders index page" do
  #       expect(post :create, user: attributes_for(:invalid_user)).to redirect_to root_url
  #     end
  #
  #     it "shows flash error" do
  #       post :create, user: attributes_for(:invalid_user)
  #       flash[:alert].should_not be_nil
  #     end
  #   end
  #
  #   describe "with correct attributes" do
  #     it "persists user to database" do
  #       expect{
  #         post :create, user: attributes_for(:full_user)
  #       }.to change{User.count}.by(1)
  #     end
  #
  #     # figure out how to actually go to user_path(:base_user)...
  #     # and this test is redundant
  #
  #     # this test takes like 20seconds
  #     it "causes 302 redirect" do
  #       post :create, user: attributes_for(:full_user)
  #       response.status.should eq(302)
  #     end
  #
  #     it "shows welcome message" do
  #       post :create, user: attributes_for(:full_user)
  #       flash[:notice].should eq("welcome")
  #     end
  #
  #     describe "performs async action" do
  #       before(:each) do
  #         ResqueSpec.reset!
  #       end
  #
  #       it "queues a welcome email" do
  #         post :create, user: attributes_for(:full_user)
  #         WelcomeEmail.should have_queue_size_of(1)
  #       end
  #
  #       it "queues a current forecast" do
  #         post :create, user: attributes_for(:full_user)
  #         CurrentForecast.should have_queue_size_of(1)
  #       end
  #     end
  #   end
  #
  # end
  #
  #
  # context "#edit" do
  #   pending
  # end
  #
  #
  # context "#update" do
  #   pending
  # end
  #
  #
  # context "#delete" do
  #   # before :each do
  #   #   @user = create(:full_user)
  #   # end
  #
  #   it "removes user from database" do
  #     pending
  #   end
  #
  #   it "redirects to index" do
  #     pending
  #   end
  # end
  #



end