require "test_helper"

class Admin::DmRoomsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_dm_rooms_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_dm_rooms_show_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_dm_rooms_destroy_url
    assert_response :success
  end
end
