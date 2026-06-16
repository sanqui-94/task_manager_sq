require "test_helper"

class RegistrationsTest < ActionDispatch::IntegrationTest
  include RegistrationTestHelper

  test "sign up page is reachable without authentication" do
    get new_registration_url

    assert_response :success
    assert_select "h1", "Sign up"
    assert_select "form[action=?]", registration_url
    assert_select "input[name='user[email_address]']"
    assert_select "input[name='user[password]']"
    assert_select "input[name='user[password_confirmation]']"
  end

  test "sign up creates a user, signs in, and redirects to the board" do
    assert_difference -> { User.count } => 1, -> { Session.count } => 1 do
      post registration_url, params: { user: valid_user_params }
    end

    assert_redirected_to root_url
    follow_redirect!
    assert_response :success

    user = User.find_by!(email_address: "newuser@example.com")
    assert_equal 1, user.sessions.count
    assert cookies[:session_id].present?
  end

  test "sign up with duplicate email re-renders the form" do
    User.create!(email_address: "taken@example.com", password: "password123", password_confirmation: "password123")

    assert_no_difference "User.count" do
      post registration_url, params: { user: valid_user_params(email_address: "taken@example.com") }
    end

    assert_response :unprocessable_entity
    assert_select "h1", "Sign up"
    assert_match(/already been taken/i, response.body)
  end

  test "sign up with mismatched passwords re-renders the form" do
    assert_no_difference "User.count" do
      post registration_url, params: { user: valid_user_params(password_confirmation: "different") }
    end

    assert_response :unprocessable_entity
    assert_select "#error_explanation", /Password confirmation.*match Password/
  end

  test "sign up with invalid email re-renders the form" do
    assert_no_difference "User.count" do
      post registration_url, params: { user: valid_user_params(email_address: "not-an-email") }
    end

    assert_response :unprocessable_entity
    assert_match(/is invalid/i, response.body)
  end

  test "sign up with blank email re-renders the form" do
    assert_no_difference "User.count" do
      post registration_url, params: { user: valid_user_params(email_address: "") }
    end

    assert_response :unprocessable_entity
    assert_select "#error_explanation", /Email address can't be blank/
  end
end
