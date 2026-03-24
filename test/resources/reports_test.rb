# frozen_string_literal: true

require 'test_helper'

class ReportsTest < Minitest::Test
  include TestHelper

  def test_list_reports
    stub_api(:get, '/api/reports', response_body: {
               'reports' => [
                 { 'id' => 1, 'title' => '日報1', 'description' => '内容1' },
                 { 'id' => 2, 'title' => '日報2', 'description' => '内容2' }
               ],
               'totalPages' => 1
             })

    client = setup_client
    data = client.reports.list

    assert_equal 2, data['reports'].size
    assert_equal '日報1', data['reports'][0]['title']
    assert_equal '内容1', data['reports'][0]['description']
  end

  def test_list_reports_with_filters
    stub_api(:get, '/api/reports',
             query: { 'user_id' => '42', 'limit' => '10' },
             response_body: { 'reports' => [{ 'id' => 1 }], 'totalPages' => 1 })

    client = setup_client
    data = client.reports.list(user_id: 42, limit: 10)

    assert_equal 1, data['reports'].size
  end

  def test_find_report
    stub_api(:get, '/api/reports/123', response_body: {
               'id' => 123,
               'title' => 'テスト日報',
               'description' => '本文です',
               'comments' => [
                 { 'id' => 1, 'description' => 'コメント' }
               ]
             })

    client = setup_client
    data = client.reports.find(123)

    assert_equal 123, data['id']
    assert_equal '本文です', data['description']
    assert_equal 1, data['comments'].size
  end

  def test_recent_reports
    stub_api(:get, '/api/reports/recents', response_body: {
               'reports' => [{ 'id' => 1 }, { 'id' => 2 }]
             })

    client = setup_client
    data = client.reports.recent

    assert_equal 2, data['reports'].size
  end
end
