class UsersController < ApplicationController
  before_filter :authenticate_user!
  # before_filter :correct_user, only: [:edit, :update_password]

	def show
		@user = User.find_by_id(params[:id]) || current_user
  end

  # TODO this pertains to editing password only: rename method?
	def edit
		@user = current_user
  end

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
      # TODO user_path doesn't currently exist
      redirect_to(user_path current_user)
      flash[:alert] = "Please log in"
    end
  end

end