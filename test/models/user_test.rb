require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid with email and password" do
    user = User.new(email_address: "user@example.com", password: "password123", password_confirmation: "password123")

    assert user.valid?
    assert user.save
    assert_equal "user@example.com", user.email_address
  end

  test "normalizes email address" do
    user = User.create!(email_address: "  User@Example.COM  ", password: "password123", password_confirmation: "password123")

    assert_equal "user@example.com", user.email_address
  end

  test "invalid without email address" do
    user = User.new(password: "password123", password_confirmation: "password123")

    assert_not user.valid?
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "invalid with malformed email address" do
    user = User.new(email_address: "not-an-email", password: "password123", password_confirmation: "password123")

    assert_not user.valid?
    assert_includes user.errors[:email_address], "is invalid"
  end

  test "invalid with duplicate email address" do
    User.create!(email_address: "taken@example.com", password: "password123", password_confirmation: "password123")
    duplicate = User.new(email_address: "taken@example.com", password: "password123", password_confirmation: "password123")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email_address], "has already been taken"
  end

  test "invalid when password confirmation does not match" do
    user = User.new(email_address: "user@example.com", password: "password123", password_confirmation: "wrong")

    assert_not user.valid?
    assert_includes user.errors[:password_confirmation], "doesn't match Password"
  end
end
