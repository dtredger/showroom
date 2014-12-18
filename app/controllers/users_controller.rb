class UsersController < ApplicationController
  before_filter :authenticated_user

	def show
		@user = current_user
  end

	def edit_password
		@user = current_user
  end

	# https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-edit-their-password
  def update_password
    @user = current_user
    if @user.update_with_password(user_params)
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to root_path
      flash[:notice] = "Password successfully changed"
    else
      flash_errors @user
      render :edit_password
    end
  end


  private
  # TODO - undefined method `permit' for "4":String
  # the user_id being passed by put/patch is interpreted as string???
  def user_params
    params.required(:user).permit(:password, :password_confirmation, :current_password)
  end

end