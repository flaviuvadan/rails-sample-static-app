class SessionsController < ApplicationController

	# Create a new session controller
	def new
	end

	# Create a session upon logging in
	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			log_in user
			remember user
			params[:session][:remember_me] == '1' ? remember(user) : forget(user)
			redirect_back_or user # equivalent to redirect_back_or(user)
		else
			flash.now[:danger] = 'Invalid email/password combination'
			render 'new'
		end
	end

	# Destroy a session upon logging out
	def destroy
		log_out if logged_in?
		redirect_to root_url
	end
end
