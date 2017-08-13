require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:example1)
    @other_user = users(:example2)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  # ログインしていないユーザーがユーザー一覧を表示させようとすると、ログインページに飛ばされるかどうかのテスト
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  # ログインしていないユーザーがユーザーを削除させようとすると、ログインページに飛ばされるかどうかのテスト
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  # ログインしているが権限のないユーザーがユーザーを削除させようとすると、トップページに飛ばされるかどうかのテスト
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end


  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end

end
