class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user

  # def index
  #    no index of all users
  # end

	def show
		@user = User.find(params[:id])
  end

  # def new
  #   implemented by devise in registrations_controller
  # end

  # def create
  #   implemented by devise in registrations_controller
  # end

  # TODO how can edit be here, but not update?
	def edit
		@user = current_user
  end

  # def update
  #   implemented by devise in registrations_controller
  # end

	# https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-edit-their-password
  def update_password
    @user = User.find(current_user.id)
    if @user.update_with_password(user_params)
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to root_path
    else
      render :edit
      flash_errors @user
    end
  end

  # def destroy
  #   implemented by devise in registrations_controller
  # end


  private

  def user_params
    params.required(:user).permit(:password, :password_confirmation, :current_password)
  end

  def flash_errors(user)
    user.errors.full_messages.each do |message|
      flash[:alert] = message
    end
  end

  def correct_user
    if not current_user == User.find_by_id(params[:id])
      redirect_to(user_path current_user)
      flash[:alert] = "Please log in"
    end
  end

end