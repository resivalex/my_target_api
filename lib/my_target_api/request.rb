# frozen_string_literal: true

require 'json'
require 'rest-client'

class MyTargetApi
  # Requests
  class Request

    def initialize(options = {})
      @options = options
    end

    def get(url, params = {})
      log_hash(method: 'Request#get', url: url, params: params)

      response = with_exception_handling do
        RestClient.get(url, headers(params).merge(query(params)))
      end

      process_response(response)
    end

    def post(url, params = {})
      log_hash(method: 'Request#post', url: url, params: params)

      response = with_exception_handling do
        RestClient.post(url, body_parameters(params), headers(params))
      end

      process_response(response)
    end

    def delete(url, params = {})
      log_hash(method: 'Request#delete', url: url, params: params)

      response = with_exception_handling do
        RestClient.delete(url, headers(params).merge(query(params)))
      end

      process_response(response)
    end

    def upload(url, content, params = {})
      log_hash(method: 'Request#upload', url: url, params: params, content: 'no logging')

      response = with_exception_handling do
        RestClient.post(url, content, headers(params).merge(query(params)))
      end

      process_response(response)
    end

    private

    attr_reader :options

    def body_parameters(params)
      result_params = params.dup
      result_params.delete(:access_token)

      if params.values.any? { |param| param.is_a? IO } || params[:grant_type]
        individual_body_parameters(params)
      else
        params.to_json
      end
    end

    def individual_body_parameters(params)
      params.map do |name, value|
        [name, value.is_a?(Array) || value.is_a?(Hash) ? value.to_json : value]
      end.to_h
    end

    def header_parameters(params)
      result_params = params.dup
      result_params.delete(:access_token)
      result_params
    end

    def query(params)
      { params: header_parameters(params) }
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
      log(response)
      response
    rescue RestClient::ExceptionWithResponse => e
      log_rest_client_exception(e)
      raise MyTargetApi::RequestError, e
    rescue RestClient::Exception => e
      log("#{e.class.name} #{e.message}")
      raise MyTargetApi::RequestError, e
    rescue SocketError => e
      raise MyTargetApi::ConnectionError, e
    end

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

      log(log_message)
    end

    def log_hash(hash)
      log(hash.map do |key, value|
        "#{key}: #{value.is_a?(String) ? value : value.inspect}"
      end.join("\n"))
    end

    def log(message)
      options[:logger] << message if options[:logger]
    end

  end
end
