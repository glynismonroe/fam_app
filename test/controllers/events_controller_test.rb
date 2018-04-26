require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  test "should get upcoming" do
    get :upcoming
    assert_response :success
  end

  test "should get past" do
    get :past
    assert_response :success
  end

end
