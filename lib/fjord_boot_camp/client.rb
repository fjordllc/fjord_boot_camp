# frozen_string_literal: true

require "faraday"
require "json"

module FjordBootCamp
  class Client
    attr_reader :configuration

    def initialize(configuration = nil)
      @configuration = configuration || FjordBootCamp.configuration || Configuration.new
    end

    def reports
      Resources::Reports.new(self)
    end

    def users
      Resources::Users.new(self)
    end

    def practices
      Resources::Practices.new(self)
    end

    def trainee_progresses
      Resources::TraineeProgresses.new(self)
    end

    def get(path, params = {})
      response = connection.get(path, params)
      handle_response(response)
    end

    private

    def connection
      @connection ||= Faraday.new(url: configuration.base_url) do |f|
        f.headers["Authorization"] = "Bearer #{configuration.access_token}" if configuration.access_token
        f.headers["Accept"] = "application/json"
        f.adapter Faraday.default_adapter
      end
    end

    def handle_response(response)
      case response.status
      when 200..299
        JSON.parse(response.body)
      when 401
        raise AuthenticationError, "Authentication failed. Check your access token."
      when 404
        raise NotFoundError, "Resource not found: #{response.env.url.path}"
      else
        raise ApiError, "API error (#{response.status}): #{response.body}"
      end
    end
  end
end
