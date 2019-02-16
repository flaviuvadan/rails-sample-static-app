require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:Starman)
		@user_2 = users(:Ford)
		log_in_as(@user)
	end

	test "following page" do
		get following_user_path(@user)
		assert_not @user.following.empty?
		assert_match @user.following.count.to_s, response.body
		@user.following.each do |user|
			assert_select "a[href=?]", user_path(user)
		end
	end

	test "followers page" do
	  get followers_user_path(@user)
		assert_not @user.followers.empty?
		assert_match @user.followers.count.to_s, response.body
		@user.followers.each do |user|
			assert_select "a[href=?]", user_path(user)
		end
	end

	test "follow user non-ajax" do
	  assert_difference '@user.following.count', 1 do
	    post relationships_path, params: { followed_id: @user_2.id }
	  end
	end

	test "follow user ajax" do
		assert_difference '@user.following.count', 1 do
			post relationships_path, xhr: true, params: { followed_id: @user_2.id }
		end
	end

	test "unfollow users non-ajax" do
	  @user.follow(@user_2)
		relationship = @user.active_relationships.find_by(followed_id: @user_2.id)
		assert_difference '@user.following.count', -1 do
			delete relationship_path(relationship)
		end
	end

	test "unfollow users ajax" do
		@user.follow(@user_2)
		relationship = @user.active_relationships.find_by(followed_id: @user_2.id)
		assert_difference '@user.following.count', -1 do
			delete relationship_path(relationship), xhr: true
		end
	end
end
