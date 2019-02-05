require 'test_helper'

class UserTest < ActiveSupport::TestCase

	def setup
		@user = User.new(name: "User", email: "user@example.com", password: "starman", password_digest: "starman")
	end

	test "should be valid" do
		assert @user.valid?
	end

	test "name should be present" do
		@user.name = " "
		assert_not @user.valid?
	end

	test "email should be present" do
		@user.email = " "
		assert_not @user.valid?
	end

	test "name should not exceed limit" do
		@user.name = "a" * 51
		assert_not @user.valid?
	end

	test "email should not exceed limit" do
		@user.email = "a" * 244 + "@example.com"
	end

	test "email validation should accept valid addresses" do
		# %w[] - a technique for making arrays of strings
	  valid_addresses = %w[user@example.com USER@foo.COM A_US_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
		valid_addresses.each do |valid_address|
		  @user.email = valid_address
			assert @user.valid?, "#{valid_address.inspect} should be valid"
		end
	end

	test "email validation should reject invalid addresses" do
	  invalid_addresses = %w[user@example,com USER_foo.com A_US_US-ER_at_foo.bar.org first.last_at_foo.jp foo@ba+baz..com]
		invalid_addresses.each do |invalid_address|
		  @user.email = invalid_address
			assert_not @user.valid?, "#{invalid_address} should be invalid"
		end
	end

	test "email addresses should be unique" do
	  duplicate_user = @user.dup
		duplicate_user.email = @user.email.upcase
		@user.save
		assert_not duplicate_user.valid?
	end

	test "email address should be saved as lower-case" do
	  mixed_cased_email = "FoO@eXaMpLe.CoM"
		@user.email = mixed_cased_email
		@user.save
		assert_equal mixed_cased_email.downcase, @user.reload.email
	end

	test "password should be present (non-blank)" do
	  @user.password = @user.password_confirmation = " " * 6
		assert_not @user.valid?
	end

	test "password should satisfy minimum length" do
	  @user.password = @user.password_confirmation = "a" * 5
		assert_not @user.valid?
	end

	test "authenticated? should return false for a user with nil digest" do
	  assert_not @user.authenticated?('')
	end
end
