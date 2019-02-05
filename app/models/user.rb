class User < ApplicationRecord
	attr_accessor :remember_token

	# note, there is a difference between a class instance variable and a class variable
	# in this case, name_limit and email_limit are class instance variables and are only accessible to an instance of a
	# User but not by descendants of the User class
	name_limit        = 50
	email_limit       = 255
	valid_email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

	validates :name,
						presence: true,
						length:   { maximum: name_limit }
	validates :email,
						presence:   true,
						length:     { maximum: email_limit },
						format:     { with: valid_email_regex },
						uniqueness: { case_sensitive: false }

	# database index might not be case-insensitive
	before_save { self.email.downcase! }

	has_secure_password
	validates :password,
						presence: true,
						length:   { minimum: 6 }

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

	# Check whether a user is authenticated based on the current remember token
	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	# Forget a user
	def forget
		update_attribute(:remember_digest, nil)
	end
end
