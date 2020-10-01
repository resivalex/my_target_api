# frozen_string_literal: true

class MyTargetApi
  # Error for request
  class RequestError < StandardError

    attr_reader :method, :url, :params, :original_exception, :response, :request_body

    def initialize(original_exception: nil)
      @original_exception = original_exception

      super(original_exception ? original_exception.message : 'No original exception')
    end

    def message
      response ? "#{response.code}: #{response.body}" : 'No response'
    end

    def set_request_info(method:, url:, params:, request_body:)
      @method = method
      @url = url
      @params = params
      @request_body = request_body
    end

    def set_response_info(response:)
      @response = response
    end

  end
end
