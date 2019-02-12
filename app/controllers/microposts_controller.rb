class MicropostsController < ApplicationController

	before_action :logged_in_user, only: [:create, :destroy]

	# Create a micropost
	def create
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash[:success] = "Micropost created"
			redirect_to root_url
		else
			render 'static_pages/home'
		end
	end

	# Destroy a micropost
	def destroy

	end

	private

		# Get the micropost params from the request
		def micropost_params
			params.require(:micropost).permit(:content)
		end
end
