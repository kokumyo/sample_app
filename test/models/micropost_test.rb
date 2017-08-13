require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:example1)
#    @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  # user_idの存在性のバリデーションに対するテスト
  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  # contentの存在性のバリデーションに対するテスト
  test "content should be present" do
    @micropost.content = "    "
    assert_not @micropost.valid?
  end

  # contentの文字数制限のバリデーションに対するテスト
  test "content should be most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  # 最新のマイクロポストがデータベース上の先頭にあるかどうかのテスト
  test "order should be recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
