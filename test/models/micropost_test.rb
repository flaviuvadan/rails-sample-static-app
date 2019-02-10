require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

	def setup
		@user = users(:Starman)
		@micropost = @user.microposts.build(content: "Lorem ipsum", user_id: @user.id)
	end

	test "is valid micropost" do
	  assert @micropost.valid?
	end

	test "user id is present" do
	  @micropost.user_id = nil
		assert_not @micropost.valid?
	end

	test "content is present" do
	  @micropost.content = "   "
		assert_not @micropost.valid?
	end

	test "content is at most 140 chars" do
	  @micropost.content = "a" * 141
		assert_not @micropost.valid?
	end

	test "order should be most recent first" do
	  assert_equal microposts(:most_recent), Micropost.first
	end
end
