# frozen_string_literal: true

require_relative 'base'

module FjordBootCamp
  module Resources
    class TraineeProgresses < Base
      # 研修生の週次進捗を取得
      # @param week_start [String, nil] 対象週の開始日 (例: "2026-03-23")。省略時は今週
      # @param company_id [Integer, nil] 企業IDで絞り込み
      def list(week_start: nil, company_id: nil)
        params = {}
        params[:week_start] = week_start if week_start
        params[:company_id] = company_id if company_id
        get('/api/trainee_progresses', params)
      end
    end
  end
end
