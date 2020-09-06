# frozen_string_literal: true

require 'json'
require_relative './nil_logger'

class MyTargetApi
  # Requests
  class LogRequestParametersDecorator

    CONTENT_OUTPUT_LIMIT = 1000

    def initialize(origin, logger: NilLogger)
      @origin = origin
      @logger = logger
    end

    def get(url, params = {})
      log_request(method: 'GET', url: url, params: params)

      origin.get(url, params)
    end

    def post(url, params = {})
      log_request(method: 'POST', url: url, params: params)

      origin.post(url, params)
    end

    def delete(url, params = {})
      log_request(method: 'DELETE', url: url, params: params)

      origin.delete(url, params)
    end

    def upload(url, content, params = {})
      log_request(method: 'POST', url: url, params: params, content: content)
      log_content(content)

      origin.upload(url, content, params)
    end

    private

    attr_reader :origin, :logger

    def log_request(method:, url:, params:, content: nil)
      logger <<
        "#{inspect_request(method: method, url: url, params: params)}#{inspect_content(content)}"
    end

    def inspect_request(method:, url:, params:)
      <<~LOG
        #{method} #{url}
        #{inspect_params(params)}
      LOG
    end

    def inspect_content(content)
      return '' unless content

      result = "Body content:\n"
      result +=
        if content.size > CONTENT_OUTPUT_LIMIT
          <<~LOG
            << first #{CONTENT_OUTPUT_LIMIT} symbols >>
            #{content[0...CONTENT_OUTPUT_LIMIT]}
          LOG
        else
          "content\n"
        end
      result
    end

    def inspect_params(params)
      if params.empty?
        'Params: No params'
      else
        "Params:\n#{params.map { |name, value| "#{name}: #{inspect_param(value)}" }.join("\n")}"
      end
    end

    def inspect_param(value)
      value.is_a?(String) ? value : value.inspect
    end

  end
end
