# frozen_string_literal: true

require "fjord_boot_camp/version"
require "fjord_boot_camp/configuration"
require "fjord_boot_camp/client"
require "fjord_boot_camp/resources/reports"
require "fjord_boot_camp/resources/users"
require "fjord_boot_camp/resources/practices"
require "fjord_boot_camp/resources/trainee_progresses"

module FjordBootCamp
  class Error < StandardError; end
  class AuthenticationError < Error; end
  class NotFoundError < Error; end
  class ApiError < Error; end

  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    def client
      @client = nil if @client&.configuration != configuration
      @client ||= Client.new(configuration)
    end

    def reset!
      @client = nil
      self.configuration = nil
    end
  end
end
