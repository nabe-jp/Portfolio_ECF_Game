require "test_helper"

class Admin::SearchesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_searches_index_url
    assert_response :success
  end
end
