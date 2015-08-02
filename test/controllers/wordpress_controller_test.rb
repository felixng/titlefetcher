require 'test_helper'

class WordpressControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get fetch" do
    get :fetch
    assert_response :success
  end

end
