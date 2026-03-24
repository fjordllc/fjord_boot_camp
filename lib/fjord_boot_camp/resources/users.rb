# frozen_string_literal: true

require_relative 'base'

module FjordBootCamp
  module Resources
    class Users < Base
      # ユーザー一覧を取得
      # @param target [String, nil] フィルタ (student, trainee, student_and_trainee, mentor, adviser, graduate等)
      # @param company_id [Integer, nil] 企業IDで絞り込み
      # @param tag [String, nil] タグで絞り込み
      # @param page [Integer, nil] ページ番号
      def list(target: nil, company_id: nil, tag: nil, page: nil)
        params = {}
        params[:target] = target if target
        params[:company_id] = company_id if company_id
        params[:tag] = tag if tag
        params[:page] = page if page
        get('/api/users', params)
      end

      # ユーザー詳細を取得
      # @param id [Integer] ユーザーID
      def find(id)
        get("/api/users/#{id}")
      end

      # 研修生一覧を取得
      def trainees
        list(target: 'trainee')
      end

      # メンター一覧を取得
      def mentors
        list(target: 'mentor')
      end
    end
  end
end
