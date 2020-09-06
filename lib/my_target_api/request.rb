# frozen_string_literal: true

require 'json'
require_relative './response_formatter'
require_relative './net_client'
require_relative './nil_logger'

class MyTargetApi
  # Requests
  class Request

    def initialize(access_token: nil, headers: {}, logger: NilLogger)
      @access_token = access_token
      @headers = headers
      @logger = logger
    end

    def get(url, params = {})
      response = with_exception_handling(params) do
        NetClient.get(url, final_headers.merge(query(params)))
      end

      process_response(response)
    end

    def post(url, params = {})
      response = with_exception_handling(params) do
        NetClient.post(url, body_parameters(params), final_headers)
      end

      process_response(response)
    end

    def delete(url, params = {})
      response = with_exception_handling(params) do
        NetClient.delete(url, final_headers.merge(query(params)))
      end

      process_response(response)
    end

    def upload(url, content, params = {})
      response = with_exception_handling(params) do
        NetClient.post(
          url,
          content,
          { 'Content-Type' => 'application/octet-stream' }.merge(final_headers).merge(query(params))
        )
      end

      process_response(response)
    end

    private

    attr_reader :access_token, :headers, :logger

    def body_parameters(params)
      result_params = params.dup

      if result_params.values.any? { |param| param.is_a? IO } || result_params[:grant_type]
        individual_body_parameters(result_params)
      else
        result_params.to_json
      end
    end

    def individual_body_parameters(params)
      params.transform_values do |value|
        value.is_a?(Array) || value.is_a?(Hash) ? value.to_json : value
      end
    end

    def query(params)
      { params: params }
    end

    def final_headers
      if access_token
        headers.merge('Authorization' => "Bearer #{access_token}")
      else
        headers
      end
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
