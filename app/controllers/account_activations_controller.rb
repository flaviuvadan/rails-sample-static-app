class AccountActivationsController < ApplicationController

	attr_accessor :remember_token, :activation_token

	before_save :downcase_email
	before_create :create_activation_digest
	validates :name, presence: true, length: { maximum: 50 }

	private

		# Convert email to lowercase before saving a user
		def downcase_email
			self.email.downcase!
		end

		# Create and assign the activation token
		def create_activation_digest
			self.activation_token = User.new_token
			self.activation_digest = User.digest(activation_token)
		end
end
