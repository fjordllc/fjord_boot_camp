# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'fjord_boot_camp'
require 'minitest/autorun'
require 'webmock/minitest'

module TestHelper
  BASE_URL = 'https://bootcamp.test'

  def setup_client(access_token: 'test-token')
    config = FjordBootCamp::Configuration.new
    config.base_url = BASE_URL
    config.access_token = access_token
    FjordBootCamp::Client.new(config)
  end

  def stub_api(method, path, response_body:, status: 200, query: nil)
    stub = stub_request(method, "#{BASE_URL}#{path}")
    stub = stub.with(query: query) if query
    stub.to_return(
      status: status,
      body: response_body.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
  end
end
