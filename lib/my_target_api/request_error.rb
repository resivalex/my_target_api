# frozen_string_literal: true

class MyTargetApi
  # Error for request
  class RequestError < StandardError

    def initialize(exception)
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
