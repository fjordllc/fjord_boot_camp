# frozen_string_literal: true

require "test_helper"

class ConfigurationTest < Minitest::Test
  def test_default_base_url
    config = FjordBootCamp::Configuration.new
    assert_equal "https://bootcamp.fjord.jp", config.base_url
  end

  def test_configure_block
    FjordBootCamp.configure do |config|
      config.base_url = "https://test.example.com"
      config.access_token = "test-token"
    end

    assert_equal "https://test.example.com", FjordBootCamp.configuration.base_url
    assert_equal "test-token", FjordBootCamp.configuration.access_token
  ensure
    FjordBootCamp.reset!
  end

  def test_reset
    FjordBootCamp.configure do |config|
      config.access_token = "token"
    end

    FjordBootCamp.reset!
    assert_nil FjordBootCamp.configuration
  end
end
