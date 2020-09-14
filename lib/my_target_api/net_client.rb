# frozen_string_literal: true

require 'json'
require 'rest-client'

class MyTargetApi
  # Requests
  class NetClient

    # NetClient response
    class Response

      def initialize(body, code, headers)
        @body = body
        @code = code
        @headers = headers
      end

      attr_reader :body, :code, :headers

    end

    # NetClient exception
    class Exception < StandardError

      def initialize(exception, message)
        @original_exception = exception

        super(message)
      end

      attr_reader :original_exception

    end

    class << self

      def get(*args)
        RestClient.get(*args) { |response, &block| process_response(response, &block) }
      rescue RestClient::Exception => e
        raise(Exception.new(e, e.message).tap { e.set_backtrace(caller) })
      end

      def post(*args)
        RestClient.post(*args) { |response, &block| process_response(response, &block) }
      rescue RestClient::Exception => e
        raise(Exception.new(e, e.message).tap { e.set_backtrace(caller) })
      end

      def delete(*args)
        RestClient.delete(*args) { |response, &block| process_response(response, &block) }
      rescue RestClient::Exception => e
        raise(Exception.new(e, e.message).tap { e.set_backtrace(caller) })
      end

      private

      def process_response(response, &block)
        result =
          case response.code
          when 200..207, 400..599
            response
          else
            response.return!(&block)
          end
        Response.new(result.body, result.code, format_headers(result.headers))
      rescue RestClient::Exception => e
        raise(Exception.new(e, e.message).tap { e.set_backtrace(caller) })
      end

      def format_headers(headers)
        headers.map do |key, value|
          [key.to_s.split('_').map(&:capitalize).join('-'), value]
        end.to_h
      end

    end

  end
end
