# frozen_string_literal: true

require "test_helper"

class UsersTest < Minitest::Test
  include TestHelper

  def test_list_users
    stub_api(:get, "/api/users", response_body: {
      "users" => [
        { "id" => 1, "login_name" => "taro", "longName" => "太郎" }
      ]
    })

    client = setup_client
    data = client.users.list
    assert_equal 1, data["users"].size
    assert_equal "taro", data["users"][0]["login_name"]
  end

  def test_list_trainees
    stub_api(:get, "/api/users",
      query: { "target" => "trainee" },
      response_body: { "users" => [{ "id" => 1, "trainee" => true }] })

    client = setup_client
    data = client.users.trainees
    assert_equal 1, data["users"].size
  end

  def test_find_user
    stub_api(:get, "/api/users/42", response_body: {
      "id" => 42, "login_name" => "hanako", "longName" => "花子"
    })

    client = setup_client
    data = client.users.find(42)
    assert_equal 42, data["id"]
    assert_equal "hanako", data["login_name"]
  end

  def test_list_mentors
    stub_api(:get, "/api/users",
      query: { "target" => "mentor" },
      response_body: { "users" => [{ "id" => 10, "mentor" => true }] })

    client = setup_client
    data = client.users.mentors
    assert_equal 1, data["users"].size
  end
end
