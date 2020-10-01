# frozen_string_literal: true

class MyTargetApi
  # Error for request
  class RequestError < StandardError

    attr_reader :method, :url, :params, :original_exception, :response

    def initialize(method:, url:, params:, original_exception: nil, response: nil)
      @method = method
      @url = url
      @params = params
      @response = response
      @original_exception = original_exception

      super(response ? "#{response.code}: #{response.body}" : 'No response')
    end

  end
end
