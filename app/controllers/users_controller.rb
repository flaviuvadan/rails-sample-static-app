class UsersController < ApplicationController

	before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
	before_action :correct_user, only: [:edit, :update]
	before_action :admin_user, only: :destroy

	# Get a list of all users
	def index
		@users = User.all.where(activated: true).paginate(page: params[:page])
	end

	# Confirm a user is an admin
	def admin_user
		redirect_to(root_url) unless current_user.admin?
	end

	# Destroy a user - admin functionality
	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User deleted"
		redirect_to users_url
	end

	# Check if the user performing a request is the currently logged in one
	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_url) unless current_user?(@user)
	end

	# Show a user
	def show
		@user       = User.find(params[:id])
		@microposts = @user.microposts.paginate(page: params[:page])
		redirect_to root_url and return unless @user.activated?
	end

	# Render a new user
	def new
		@user = User.new
	end

	# Create and save a user
	def create
		@user = User.new(user_params)
		if @user.save
			@user.send_activation_email
			flash[:info] = "Please check your email to activate your account."
			redirect_to root_url
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

	def following
		@title = "Following"
		@user = User.find(params[:id])
		@users = @user.following.paginate(page: params[:page])
		render 'show_follow'
	end

	def followers
		@title = "Followers"
		@user = User.find(params[:id])
		@users = @user.followers.paginate(page: params[:page])
		render 'show_follow'
	end

	private

		# Specifies the params that are allowed
		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation)
		end
end
