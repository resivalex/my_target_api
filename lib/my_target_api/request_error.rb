# frozen_string_literal: true

class MyTargetApi
  # Error for request
  class RequestError < StandardError

    attr_reader :params, :original_exception, :response

    def initialize(params:, original_exception: nil, response: nil)
      @params = params
      @response = response
      @original_exception = original_exception

      message =
        "#{(response ? "#{response.code}: #{response.body}. " : '')}"\
        'Inspect #params, #response and #original_exception for more details'

      super(message)
    end

  end
end
