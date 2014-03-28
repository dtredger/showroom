class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

	
	# def facebook
	# 	auth = request.env['omniauth.auth']
	# 	token = auth.credentials.token

	# 	identity = User.where(fb_uid: auth.uid).first

	# 	if identity
	# 		# then we found a matching user in our system
	# 		identity.update_facebook_info(auth)
	# 		sign_in_and_redirect(:user, identity)
	# 	elsif current_user
	# 		# perhaps a current user is linking facebook to their already established account
	# 		current_user.update_facebook_info(auth)
	# 		sign_in_and_redirect(:user, identity)
	# 	elsif #check for session and begin registration
	# 	else # there was an error redirect to '/'
	# 	end
	# end

end