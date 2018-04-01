# frozen_string_literal: true

require 'json'
require 'rest-client'

class MyTargetApi
  # Requests
  class Request

    def initialize(options = {})
      @logger = options[:logger]
    end

    def get(url, params = {})
      response = with_exception_handling do
        RestClient::Request.execute(
          method: :get,
          url: url,
          headers: header_parameters(params).merge(headers(params))
        )
      end

      process_response(response)
    end

    def post(url, params = {})
      response = with_exception_handling do
        RestClient::Request.execute(
          method: :post,
          url: url,
          payload: body_parameters(params),
          headers: headers(params)
        )
      end

      process_response(response)
    end

    def delete(url, params = {})
      result_params = params.dup
      result_params.delete(:access_token)
      response = with_exception_handling do
        RestClient::Request.execute(
          method: :delete,
          url: url,
          headers: header_parameters(params).merge(headers(params))
        )
      end

      process_response(response)
    end

    def body_parameters(params)
      result_params = params.dup
      result_params.delete(:access_token)

      if params.values.any? { |param| param.is_a? IO } || params[:grant_type]
        params.map do |name, value|
          [name, value.is_a?(Array) || value.is_a?(Hash) ? value.to_json : value]
        end.to_h
      else
        params.to_json
      end
    end

    def header_parameters(params)
      result_params = params.dup
      result_params.delete(:access_token)
      result_params
    end

    def headers(params)
      { Authorization: "Bearer #{params[:access_token]}" }
    end

    def process_response(response)
      JSON.parse(response.body)
    rescue JSON::ParserError
      response.body
    end

    def with_exception_handling
      response = yield
      logger << response if logger
      response
    rescue RestClient::Unauthorized, RestClient::Forbidden,
           RestClient::BadRequest, RestClient::RequestFailed,
           RestClient::ResourceNotFound => e

      log_rest_client_exception(e)
      raise MyTargetApi::RequestError, e
    rescue SocketError => e
      raise MyTargetApi::ConnectionError, e
    end

    private

    attr_reader :logger

    def log_rest_client_exception(exception)
      log_message =
        <<-LOG
        RestClient exception
          Class: #{exception.class}
          Message: #{exception.message}
          HTTP Code: #{exception.http_code}
          HTTP Body: #{exception.http_body}
          HTTP headers: #{exception.http_headers}
        LOG

      logger << log_message if logger
    end

  end
end
