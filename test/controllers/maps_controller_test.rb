require 'test_helper'

class MapsControllerTest < ActionController::TestCase
  test "should get google_maps" do
    get :google_maps
    assert_response :success
  end

end
