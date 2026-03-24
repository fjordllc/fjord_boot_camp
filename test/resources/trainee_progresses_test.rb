# frozen_string_literal: true

require "test_helper"

class TraineeProgressesTest < Minitest::Test
  include TestHelper

  def test_list_trainee_progresses
    stub_api(:get, "/api/trainee_progresses", response_body: {
      "weekStart" => "2026-03-23",
      "weekEnd" => "2026-03-27",
      "trainees" => [
        {
          "id" => 1,
          "loginName" => "taro",
          "longName" => "研修太郎",
          "company" => { "id" => 1, "name" => "A社" },
          "course" => { "id" => 1, "title" => "Railsコース" },
          "weeklyActivity" => {
            "reportCount" => 4,
            "weekdays" => 5,
            "reportDates" => ["2026-03-23", "2026-03-24", "2026-03-25", "2026-03-26"],
            "practiceStatusChanges" => 1,
            "practiceChanges" => [
              { "practiceTitle" => "Railsのテスト", "status" => "complete" }
            ]
          },
          "currentPractice" => {
            "id" => 10,
            "title" => "ポリモーフィズム",
            "daysOnPractice" => 2
          },
          "overallProgress" => {
            "completedPracticesCount" => 28,
            "requiredPracticesCount" => 65,
            "completedPercentage" => 43.1
          }
        }
      ]
    })

    client = setup_client
    data = client.trainee_progresses.list
    assert_equal "2026-03-23", data["weekStart"]
    assert_equal 1, data["trainees"].size

    trainee = data["trainees"][0]
    assert_equal "研修太郎", trainee["longName"]
    assert_equal 4, trainee["weeklyActivity"]["reportCount"]
    assert_equal 43.1, trainee["overallProgress"]["completedPercentage"]
  end

  def test_list_with_week_start
    stub_api(:get, "/api/trainee_progresses",
      query: { "week_start" => "2026-03-16" },
      response_body: { "weekStart" => "2026-03-16", "weekEnd" => "2026-03-20", "trainees" => [] })

    client = setup_client
    data = client.trainee_progresses.list(week_start: "2026-03-16")
    assert_equal "2026-03-16", data["weekStart"]
  end

  def test_list_with_company_id
    stub_api(:get, "/api/trainee_progresses",
      query: { "company_id" => "1" },
      response_body: { "weekStart" => "2026-03-23", "weekEnd" => "2026-03-27", "trainees" => [] })

    client = setup_client
    data = client.trainee_progresses.list(company_id: 1)
    assert_empty data["trainees"]
  end
end
