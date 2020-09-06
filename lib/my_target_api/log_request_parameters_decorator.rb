# frozen_string_literal: true

require 'json'
require_relative './nil_logger'

class MyTargetApi
  # Requests
  class LogRequestParametersDecorator

    def initialize(origin, logger: NilLogger)
      @origin = origin
      @logger = logger
    end

    def get(url, params = {})
      log_hash(method: 'Request#get', url: url, params: params)

      origin.get(url, params)
    end

    def post(url, params = {})
      log_hash(method: 'Request#post', url: url, params: params)

      origin.post(url, params)
    end

    def delete(url, params = {})
      log_hash(method: 'Request#delete', url: url, params: params)

      origin.delete(url, params)
    end

    def upload(url, content, params = {})
      log_hash(method: 'Request#upload', url: url, params: params, content: 'no logging')

      origin.upload(url, content, params)
    end

    private

    attr_reader :origin, :logger

    def log_hash(hash)
      logger << inspect_hash(hash)
    end

    def inspect_hash(hash)
      hash.map do |key, value|
        "#{key}: #{value.is_a?(String) ? value : value.inspect}"
      end.join("\n")
    end

  end
end
