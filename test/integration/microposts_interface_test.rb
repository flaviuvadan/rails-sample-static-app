require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
		@user = users(:Starman)
	end

	test "micropost interface" do
	  log_in_as(@user)
		get root_path
		assert_select 'div.pagination'
		assert_select 'input[type=file]'

		# invalid submission
		assert_no_difference 'Micropost.count' do
		  post microposts_path, params: {
					micropost: {
							content: "",
					},
			}
		end
		assert_select 'div#error_explanation'

		# valid submission
		content = "content"
		picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
		assert_difference 'Micropost.count', 1 do
		  post microposts_path, params: {
					micropost: {
							content: content,
							picture: picture,
					}
			}
		end
		assert_redirected_to root_url
		follow_redirect!
		assert_match content, response.body

		# delete a post
		assert_select 'a', text: 'delete'
		first_micropost = @user.microposts.paginate(page: 1).first
		assert_difference 'Micropost.count', -1 do
		  delete micropost_path(first_micropost)
		end

		# visit different user, should see no delete links
		get user_path(users(:Zaphod))
		assert_select 'a', text: 'delete', count: 0
	end

	test "micropost sidebar count" do
	  log_in_as(@user)
		get root_path
		assert_match "31 microposts", response.body

		# user with zero microposts
		user_2 = users(:Zaphod)
		log_in_as(user_2)
		get root_path
		assert_match "0 microposts", response.body
		user_2.microposts.create!(content: "content")
		get root_path
		assert_match "1 micropost", response.body
	end
end
