require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                    password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name sholud be present" do
    @user.name = "    "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation sholud accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid?, "#{address.inspect} should be valid"
    end
  end

  test "email validation sholud reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com ]

    invalid_addresses.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be present (noblank)" do
    @user.password = @user.password_confirmation = " " * 6;
    assert_not @user.valid?
  end

  test "password should be have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5;
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end


  # ユーザー削除時に関連するマイクロポストが破棄されるかどうかのテスト
  test "associated microposts sholud be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end


  test "should follow and unfollow a user" do
    user1 = users(:example1)
    user2 = users(:example4)
    assert_not user1.following?(user2)
    user1.follow(user2)
    assert user1.following?(user2)
    assert user2.followers.include?(user1)
    user1.unfollow(user2)
    assert_not user1.following?(user2)
  end


  test "feed should have the raight posts" do
    user = users(:example1)
    user_followed = users(:example2)
    user_unfollow = users(:example4)

    user.microposts.each do |post_self|
      assert user.feed.include?(post_self)
    end
    user_followed.microposts.each do |post_following|
      assert user.feed.include?(post_following)
    end
    user_unfollow.microposts.each do |post_unfollow|
      assert_not user.feed.include?(post_unfollow)
    end
  end

end