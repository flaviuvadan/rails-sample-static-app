class MicropostsController < ApplicationController

	before_action :logged_in_user, only: [:create, :destroy]

	# Create a micropost
	def create

	end

	# Destroy a micropost
	def destroy

	end
end
