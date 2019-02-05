ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
# get default Rails tests to show RED/GREEN results
require 'minitest/reporters'
Minitest::Reporters.use!

# Responsible for test cases
class ActiveSupport::TestCase
	# Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
	fixtures :all
	include ApplicationHelper

	# Check whether a user is logged in
	def is_logged_in?
		!session[:user_id].nil?
	end

	# Log in as the given user
	def log_in_as(user)
		session[:user_id] = user.id
	end
end


# Responsible for integration tests
class ActionDispatch::IntegrationTest

	# Log in as the given user
	def log_in_as(user, password: 'password', remember_me: '1')
		post login_path, params: {
				session: {
						email:       user.email,
						password:    password,
						remember_me: remember_me,
				},
		}
	end
end