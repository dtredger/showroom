class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

	# Handle OmniAuth redirect for Facebook
	def facebook
		auth = request.env['omniauth.auth']
		identity = User.where(fb_uid: auth.uid).first

		if identity
			# Then we found a matching user in our system, sign him in.
			identity.update_facebook_info(auth)
			sign_in_and_redirect identity
		elsif current_user
			# Then a user is linking Facebook to their already established account.
			current_user.update_facebook_info(auth)
			sign_in_and_redirect identity
		else
			# A user is registering through Facebook
			# Store the their Facebook info in a session and redirect them to the registration page
			set_fb_session(auth)
			redirect_to update_user_facebook_confirmation_path
		end
	end

	protected

	# Store Facebook info in a session
	def set_fb_session(auth)
		session[:fb_uid] = auth.uid
		session[:fb_token] = auth.credentials.token
		session[:fb_token_expiration] = Time.at(auth['credentials'].expires_at)
	end

end