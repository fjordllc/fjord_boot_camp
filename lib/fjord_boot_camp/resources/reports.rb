# frozen_string_literal: true

require_relative "base"

module FjordBootCamp
  module Resources
    class Reports < Base
      # 日報一覧を取得
      # @param user_id [Integer, nil] ユーザーIDで絞り込み
      # @param practice_id [Integer, nil] プラクティスIDで絞り込み
      # @param company_id [Integer, nil] 企業IDで絞り込み
      # @param limit [Integer, nil] 取得件数
      # @param page [Integer, nil] ページ番号
      def list(user_id: nil, practice_id: nil, company_id: nil, limit: nil, page: nil)
        params = {}
        params[:user_id] = user_id if user_id
        params[:practice_id] = practice_id if practice_id
        params[:company_id] = company_id if company_id
        params[:limit] = limit if limit
        params[:page] = page if page
        get("/api/reports", params)
      end

      # 日報詳細を取得（コメント・プラクティス付き）
      # @param id [Integer] 日報ID
      def find(id)
        get("/api/reports/#{id}")
      end

      # 最近の日報を取得（直近20件）
      def recent
        get("/api/reports/recents")
      end
    end
  end
end
