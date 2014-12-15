class ApplicationController < ActionController::Base
	before_filter :configure_permitted_parameters, if: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

  def authenticated_user
    redirect_to new_user_session_path if current_user.nil?
  end

  def correct_user
    if not current_user == User.find_by_id(params[:id])
      # TODO user_path doesn't currently exist
      redirect_to(user_path current_user)
      flash[:alert] = "Please log in"
    end
  end

  def flash_errors(resource)
    resource.errors.full_messages.each do |message|
      flash[:alert] = message
    end
  end


end
