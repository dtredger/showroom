class UsersController < ApplicationController
  before_filter :authenticated_user

	def show
		@user = current_user
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
      flash[:notice] = "Password successfully changed"
    else
      flash_errors @user
      render :edit
    end
  end


  private

  def user_params
    params.required(:user).permit(:password, :password_confirmation, :current_password)
  end

end