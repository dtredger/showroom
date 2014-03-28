class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

	def facebook
		auth = request.env['omniauth.auth']
		token = auth.credentials.token

		identity = User.where(fb_uid: auth.uid).first

		if identity
			# then we found a matching user in our system
			identity.update_facebook_info(auth)
			sign_in_and_redirect(:user, identity)
		elsif current_user
			# A current user is linking facebook to their already established account
			current_user.update_facebook_info(auth)
			sign_in_and_redirect(:user, identity)
		else
			set_fb_session(auth)
			# redirect to facebook page
		end
	end

	protected

	def set_fb_session(auth)
		session[:fb_uid] = auth.uid
		session[:fb_token] = auth.credentials.token
		session[:fb_expires_at] = Time.at(auth['credentials'].expires_at)
	end

end