class PasswordResetsController < ApplicationController

  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiry, only: [:edit, :update]

  def new
  end

  def edit
  end

  # Initiate a password reset workflow
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "cannot be empty")
      render 'edit'
		elsif @user.update_attributes(user_params)
			log_in(@user)
			flash[:success] = "Password has been reset"
			redirect_to @user
    end
  end

  private

		# Defines allowed params
		def user_params
			params.require(:user).permit(:password, :password_confirmation)
		end

    # Get the user submitting the password reset
    def get_user
      @user = User.find_by(:email, params[:email])
    end

    # Confirm user is valid
    def valid_user
      unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
        redirect_to root_url
      end
    end

    # Check whether a reset token has expired
    def check_expiry
      if @user.password_reset_expired?
        flash[:danger] = "Password reset expired"
        redirect_to new_password_reset_url
      end
    end
end
