require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get admin_dashboard_top_url
    assert_response :success
  end
end
