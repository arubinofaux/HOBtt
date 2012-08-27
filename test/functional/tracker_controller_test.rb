require 'test_helper'

class TrackerControllerTest < ActionController::TestCase
  test "should get announce" do
    get :announce
    assert_response :success
  end

  test "should get scrape" do
    get :scrape
    assert_response :success
  end

end
