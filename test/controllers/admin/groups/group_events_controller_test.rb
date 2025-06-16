require "test_helper"

class Admin::Groups::GroupEventsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_groups_group_events_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_groups_group_events_show_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_groups_group_events_destroy_url
    assert_response :success
  end
end
