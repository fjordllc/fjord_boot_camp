# frozen_string_literal: true

require 'test_helper'

class CommentsTest < Minitest::Test
  include TestHelper

  def test_list_comments
    stub_api(:get, '/api/comments',
             query: { 'commentable_type' => 'Report', 'commentable_id' => '123' },
             response_body: {
               'comments' => [
                 { 'id' => 1, 'description' => 'コメント1' },
                 { 'id' => 2, 'description' => 'コメント2' }
               ]
             })

    client = setup_client
    data = client.comments.list(commentable_type: 'Report', commentable_id: 123)

    assert_equal 2, data['comments'].size
    assert_equal 'コメント1', data['comments'][0]['description']
  end

  def test_create_comment
    stub_request(:post, "#{BASE_URL}/api/comments")
      .with(
        body: {
          commentable_type: 'Report',
          commentable_id: 123,
          comment: { description: 'テストコメント' }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
      .to_return(
        status: 201,
        body: { 'id' => 10, 'description' => 'テストコメント' }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    client = setup_client
    data = client.comments.create(
      commentable_type: 'Report',
      commentable_id: 123,
      description: 'テストコメント'
    )

    assert_equal 10, data['id']
  end

  def test_update_comment
    stub_request(:patch, "#{BASE_URL}/api/comments/10")
      .with(
        body: { comment: { description: '更新コメント' } }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
      .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })

    client = setup_client
    client.comments.update(10, description: '更新コメント')
  end

  def test_destroy_comment
    stub_request(:delete, "#{BASE_URL}/api/comments/10")
      .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })

    client = setup_client
    client.comments.destroy(10)
  end
end
