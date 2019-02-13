class MicropostsController < ApplicationController

	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user, only: :destroy

	# Create a micropost
	def create
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash[:success] = "Micropost created"
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	# Destroy a micropost
	def destroy
		@micropost.destroy
		flash[:success] = "Micropost deleted"
		redirect_to request.referrer || root_url
	end

	private

		# Get the micropost params from the request
		def micropost_params
			params.require(:micropost).permit(:content)
		end

		# Check whether a post is associated with the correct user
		def correct_user
			@micropost = current_user.microposts.find_by(id: params[:id])
			redirect_to root_url if @micropost.nil?
		end
end
