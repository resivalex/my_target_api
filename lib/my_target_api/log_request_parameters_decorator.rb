# frozen_string_literal: true

require 'json'
require_relative './response_formatter'
require_relative './net_client'

class MyTargetApi
  # Requests
  class LogRequestParametersDecorator

    def initialize(origin, options = {})
      @origin = origin
      @options = options
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

    attr_reader :origin, :options

    def log_hash(hash)
      log(hash.map do |key, value|
        "#{key}: #{value.is_a?(String) ? value : value.inspect}"
      end.join("\n"))
    end

    def log(message)
      options[:logger] << message if options[:logger]
    end

  end
end
