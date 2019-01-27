class User < ApplicationRecord
	# note, there is a difference between a class instance variable and a class variable
	# in this case, name_limit and email_limit are class instance variables and are only accessible to an instance of a
	# User but not by descendants of the User class
	name_limit        = 50
	email_limit       = 255
	valid_email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

	validates :name, presence: true,
						length:          { maximum: name_limit }
	validates :email, presence: true,
						length:           { maximum: email_limit },
						format:           { with: valid_email_regex },
						uniqueness:       { case_sensitive: false }

	# database index might not be case-insensitive
	before_save { self.email.downcase! }

	has_secure_password
end
