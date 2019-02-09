class User < ApplicationRecord

	attr_accessor :remember_token, :activation_token

	before_create :create_activation_digest
	before_save :downcase_email

	# note, there is a difference between a class instance variable and a class variable
	# in this case, name_limit and email_limit are class instance variables and are only accessible to an instance of a
	# User but not by descendants of the User class
	name_limit        = 50
	email_limit       = 255
	valid_email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	# validators
	validates :name,
						presence: true,
						length:   { maximum: name_limit }
	validates :email,
						presence:   true,
						length:     { maximum: email_limit },
						format:     { with: valid_email_regex },
						uniqueness: { case_sensitive: false }

	has_secure_password
	validates :password,
						presence:  true,
						length:    { minimum: 6 },
						allow_nil: true

	# Create an encrypted version of the given string
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	# Create a url safe, base-64 encoded token
	def User.new_token
		SecureRandom.urlsafe_base64
	end

	# Remember the current user's token
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# Check whether a user is authenticated based on the current remember token (attribute - remember/activation)
	def authenticated?(attribute, token)
		# using a form of meta-programming to run remember_digest
		digest = send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	# Forget a user
	def forget
		update_attribute(:remember_digest, nil)
	end

	# Sends activation email
	def send_activation_email
		UserMailer.account_activation(self).deliver_now
	end

	# Converts email to all lower-case
	def downcase_email
		self.email.downcase!
	end

	# Create the token and digest
	def create_activation_digest
		self.activation_token  = User.new_token
		self.activation_digest = User.digest(activation_token)
	end
end
