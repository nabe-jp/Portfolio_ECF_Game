require "test_helper"

class Public::AllUserPostsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_all_user_posts_index_url
    assert_response :success
  end
end
