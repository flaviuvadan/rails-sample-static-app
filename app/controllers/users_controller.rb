class UsersController < ApplicationController

	before_action :logged_in_user, only: [:index, :edit, :update]
	before_action :correct_user, only: [:edit, :update]

	# Get a list of all users
	def index
		@users = User.all
	end

	# Check if a user is logged in
	def logged_in_user
		unless logged_in?
			store_location
			flash[:danger] = "Please log in."
			redirect_to login_url
		end
	end

	# Check if the user performing a request is the currently logged in one
	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_url) unless current_user?(@user)
	end

	# Show a user
  def show
    @user = User.find(params[:id])
  end

	# Render a new user
  def new
    @user = User.new
	end

	# Create and save a use
	def create
		@user = User.new(user_params)
		if @user.save
			log_in(@user)
			flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
		else
			render 'new'
		end
	end

	# Access a user for edit
	def edit
		@user = User.find_by(params[:id])
	end

	# Update a user's attributes
	def update
		@user = User.find(params[:id])
		if @user.update_attributes(user_params)
			flash[:success] = "Profile updated"
			redirect_to @user
		else
			render 'edit'
		end
	end

	private

		# Specifies the params that are allowed
		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation)
		end
end
