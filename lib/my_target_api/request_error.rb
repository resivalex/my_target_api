# frozen_string_literal: true

class MyTargetApi
  # Error for request
  class RequestError < StandardError

    attr_reader :original_exception
    attr_reader :params

    def initialize(params, original_exception: nil, response: nil)
      @params = params
      @original_exception = original_exception
      super(build_message(response))
    end

    private

    def build_message(response)
      body = JSON.parse response
      if body['error']
        "#{body['error']} : #{body['error_description']}"
      else
        body.map { |field, error| "#{field}: #{error}" }.join(', ')
      end
    rescue StandardError
      response
    end

  end
end
