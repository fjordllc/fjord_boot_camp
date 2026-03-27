# frozen_string_literal: true

require_relative 'base'

module FjordBootCamp
  module Resources
    class Comments < Base
      # コメント一覧を取得
      # @param commentable_type [String] コメント対象の種類 (例: "Report", "Product")
      # @param commentable_id [Integer] コメント対象のID
      # @param limit [Integer, nil] 取得件数
      # @param offset [Integer, nil] オフセット
      def list(commentable_type:, commentable_id:, limit: nil, offset: nil)
        params = {
          commentable_type: commentable_type,
          commentable_id: commentable_id
        }
        params[:comment_limit] = limit if limit
        params[:comment_offset] = offset if offset
        get('/api/comments', params)
      end

      # コメントを作成
      # @param commentable_type [String] コメント対象の種類 (例: "Report", "Product")
      # @param commentable_id [Integer] コメント対象のID
      # @param description [String] コメント本文（Markdown対応）
      def create(commentable_type:, commentable_id:, description:)
        client.post('/api/comments', {
          commentable_type: commentable_type,
          commentable_id: commentable_id,
          comment: { description: description }
        })
      end

      # コメントを更新
      # @param id [Integer] コメントID
      # @param description [String] 新しいコメント本文
      def update(id, description:)
        client.patch("/api/comments/#{id}", {
          comment: { description: description }
        })
      end

      # コメントを削除
      # @param id [Integer] コメントID
      def destroy(id)
        client.delete("/api/comments/#{id}")
      end
    end
  end
end
