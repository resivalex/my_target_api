# frozen_string_literal: true

class MyTargetApi
  # Error for request
  class RequestError < StandardError

    attr_reader :original_exception
    attr_reader :params

    def initialize(exception, params)
      @original_exception = exception
      @params = params
      super build_message exception
    end

    private

    def build_message(exception)
      body = JSON.parse exception.response
      if body['error']
        "#{body['error']} : #{body['error_description']}"
      else
        body.map { |field, error| "#{field}: #{error}" }.join(', ')
      end
    rescue StandardError
      exception.response
    end

  end
end
