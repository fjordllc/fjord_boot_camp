# frozen_string_literal: true

require_relative "base"

module FjordBootCamp
  module Resources
    class Practices < Base
      # プラクティス一覧を取得
      def list
        get("/api/practices")
      end

      # プラクティス詳細を取得
      # @param id [Integer] プラクティスID
      def find(id)
        get("/api/practices/#{id}")
      end
    end
  end
end
