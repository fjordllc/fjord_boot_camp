# frozen_string_literal: true

module FjordBootCamp
  module Resources
    class Base
      attr_reader :client

      def initialize(client)
        @client = client
      end

      private

      def get(path, params = {})
        client.get(path, params)
      end
    end
  end
end
