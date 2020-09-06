# frozen_string_literal: true

require 'json'
require_relative './response_formatter'
require_relative './net_client'
require_relative './nil_logger'

class MyTargetApi
  # Requests
  class Request

    def initialize(logger: NilLogger)
      @logger = logger
    end

    def get(url, params = {}, headers = {})
      response = with_exception_handling(params) do
        NetClient.get(url, headers.merge(query(params)))
      end

      process_response(response)
    end

    def post(url, params = {}, headers = {})
      response = with_exception_handling(params) do
        NetClient.post(url, params, headers)
      end

      process_response(response)
    end

    def delete(url, params = {}, headers = {})
      response = with_exception_handling(params) do
        NetClient.delete(url, headers.merge(query(params)))
      end

      process_response(response)
    end

    def upload(url, content, params = {}, headers = {})
      response = with_exception_handling(params) do
        NetClient.post(
          url,
          content,
          { 'Content-Type' => 'application/octet-stream' }
            .merge(headers)
            .merge(query(params))
        )
      end

      process_response(response)
    end

    private

    attr_reader :logger

    def query(params)
      { params: params }
    end

    def process_response(response)
      JSON.parse(response.body)
    rescue JSON::ParserError
      response.body
    end

    def with_exception_handling(params)
      response = yield
      log_response(response)
      raise_with_params(params: params, response: response) if response.code >= 400
      response
    rescue NetClient::Exception => e
      original_exception = e.original_exception
      logger << "#{original_exception.class.name} #{original_exception.message}"
      raise_with_params(params: params, original_exception: original_exception)
    end

    def log_response(response)
      logger << ResponseFormatter.new(response).format
    end

    def raise_with_params(params:, response: nil, original_exception: nil)
      result = MyTargetApi::RequestError.new(params: params,
                                             response: response,
                                             original_exception: original_exception)
      result.set_backtrace(caller)
      raise result
    end

  end
end
