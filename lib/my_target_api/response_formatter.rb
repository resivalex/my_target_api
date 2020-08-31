# frozen_string_literal: true

require 'json'

class MyTargetApi
  # Format response
  class ResponseFormatter

    def initialize(response)
      @response = response
    end

    def format
      headers = response.headers.empty? ? ' No headers' : "\n#{headers_in_lines}"
      body = response.body.to_s == '' ? ' No body' : "\n#{response.body}"
      <<~RESPONSE
        HTTP Code: #{response.code}
        HTTP Body:#{body}
        HTTP Headers:#{headers}
      RESPONSE
    end

    private

    attr_reader :response

    def headers_in_lines
      headers.map do |name, value|
        "#{name}: #{value}"
      end.join("\n")
    end

    def headers
      @_headers ||= response.headers
    end

  end
end
