# frozen_string_literal: true

require 'json'
require_relative './response_formatter'
require_relative './net_client'

class MyTargetApi
  # Requests
  class Request

    def initialize(options = {})
      @options = options
    end

    def get(url, params = {})
      response = with_exception_handling(params) do
        NetClient.get(url, headers.merge(query(params)))
      end

      process_response(response)
    end

    def post(url, params = {})
      response = with_exception_handling(params) do
        NetClient.post(url, body_parameters(params), headers)
      end

      process_response(response)
    end

    def delete(url, params = {})
      response = with_exception_handling(params) do
        NetClient.delete(url, headers.merge(query(params)))
      end

      process_response(response)
    end

    def upload(url, content, params = {})
      response = with_exception_handling(params) do
        NetClient.post(
          url,
          content,
          headers.merge(query(params)).merge('Content-Type' => 'application/octet-stream')
        )
      end

      process_response(response)
    end

    private

    attr_reader :options

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

    def headers
      if access_token
        optional_headers.merge('Authorization' => "Bearer #{access_token}")
      else
        optional_headers
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
      log("#{original_exception.class.name} #{original_exception.message}")
      raise_with_params(params: params, original_exception: original_exception)
    end

    def log_response(response)
      log(ResponseFormatter.new(response).format)
    end

    def headers_to_string(headers)
      headers.map do |name, value|
        "#{name}: #{value}"
      end.join("\n")
    end

    def raise_with_params(params:, response: nil, original_exception: nil)
      result = MyTargetApi::RequestError.new(params: params,
                                             response: response,
                                             original_exception: original_exception)
      result.set_backtrace(caller)
      raise result
    end

    def log(message)
      options[:logger] << message if options[:logger]
    end

    def access_token
      options[:access_token]
    end

    def optional_headers
      options[:headers] || {}
    end

  end
end
