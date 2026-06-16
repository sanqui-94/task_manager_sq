ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
  end
end

module RegistrationTestHelper
  def valid_user_params(overrides = {})
    {
      email_address: "newuser@example.com",
      password: "password123",
      password_confirmation: "password123"
    }.merge(overrides)
  end
end
