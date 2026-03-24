# frozen_string_literal: true

require "test_helper"

class ClientTest < Minitest::Test
  include TestHelper

  def test_sends_authorization_header
    stub_api(:get, "/api/reports", response_body: { reports: [] })

    client = setup_client(access_token: "my-token")
    client.get("/api/reports")

    assert_requested :get, "#{BASE_URL}/api/reports",
      headers: { "Authorization" => "Bearer my-token" }
  end

  def test_raises_authentication_error_on_401
    stub_api(:get, "/api/reports", response_body: { error: "unauthorized" }, status: 401)

    client = setup_client
    assert_raises(FjordBootCamp::AuthenticationError) do
      client.get("/api/reports")
    end
  end

  def test_raises_not_found_error_on_404
    stub_api(:get, "/api/reports/999", response_body: { error: "not found" }, status: 404)

    client = setup_client
    assert_raises(FjordBootCamp::NotFoundError) do
      client.get("/api/reports/999")
    end
  end

  def test_raises_api_error_on_500
    stub_api(:get, "/api/reports", response_body: { error: "internal" }, status: 500)

    client = setup_client
    assert_raises(FjordBootCamp::ApiError) do
      client.get("/api/reports")
    end
  end

  def test_parses_json_response
    stub_api(:get, "/api/reports", response_body: { "reports" => [{ "id" => 1 }] })

    client = setup_client
    data = client.get("/api/reports")
    assert_equal [{ "id" => 1 }], data["reports"]
  end
end
