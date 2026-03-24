# frozen_string_literal: true

require "test_helper"

class PracticesTest < Minitest::Test
  include TestHelper

  def test_list_practices
    stub_api(:get, "/api/practices", response_body: {
      "practices" => [
        { "id" => 1, "title" => "CSS入門" },
        { "id" => 2, "title" => "Railsのテスト" }
      ]
    })

    client = setup_client
    data = client.practices.list
    assert_equal 2, data["practices"].size
  end

  def test_find_practice
    stub_api(:get, "/api/practices/1", response_body: {
      "id" => 1, "title" => "CSS入門"
    })

    client = setup_client
    data = client.practices.find(1)
    assert_equal "CSS入門", data["title"]
  end
end
