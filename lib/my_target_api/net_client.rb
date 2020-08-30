# frozen_string_literal: true

require 'json'
require 'rest-client'

class MyTargetApi
  # Requests
  class NetClient

    # NetClient response
    class Response

      def initialize(body, code)
        @body = body
        @code = code
      end

      attr_reader :body, :code

    end

    # NetClient exception
    class Exception < StandardError

      def initialize(exception, message)
        @original_exception = exception
        @message = message
      end

      attr_reader :original_exception

    end

    def self.get(*args)
      RestClient.get(*args) { |response, &block| process_response(response, &block) }
    rescue StandardError => e
      raise Exception.new(e, e.message)
    end

    def self.post(*args)
      RestClient.post(*args) { |response, &block| process_response(response, &block) }
    rescue StandardError => e
      raise Exception.new(e, e.message)
    end

    def self.delete(*args)
      RestClient.delete(*args) { |response, &block| process_response(response, &block) }
    rescue StandardError => e
      raise Exception.new(e, e.message)
    end

    def self.process_response(response, &block)
      result =
        case response.code
        when 200..207, 400..599
          response
        else
          response.return!(&block)
        end
      Response.new(result.body, result.code)
    rescue StandardError => e
      raise Exception.new(e, e.message)
    end

  end
end
