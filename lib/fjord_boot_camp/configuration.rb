# frozen_string_literal: true

module FjordBootCamp
  class Configuration
    attr_accessor :base_url, :access_token

    def initialize
      @base_url = ENV.fetch('BOOTCAMP_URL', 'https://bootcamp.fjord.jp')
      @access_token = ENV.fetch('BOOTCAMP_ACCESS_TOKEN', nil)
    end
  end
end
