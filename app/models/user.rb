class User < ApplicationRecord
	# note, there is a difference between a class instance variable and a class variable
	# in this case, name_limit and email_limit are class instance variables and are only accessible to an instance of a
	# User but not by descendants of the User class
	@name_limit  = 50
	@email_limit = 255

	validates :name, presence: true, length: { maximum: @name_limit }
	validates :email, presence: true, length: { maximum: @email_limit }
end
