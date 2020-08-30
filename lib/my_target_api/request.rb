# frozen_string_literal: true

require 'json'

class MyTargetApi
  # Requests
  class Request

    def initialize(options = {})
      @options = options
    end

    def get(url, params = {})
      log_hash(method: 'Request#get', url: url, params: params)

      response = with_exception_handling(params) do
        NetClient.get(url, headers.merge(query(params)))
      end

      process_response(response)
    end

    def post(url, params = {})
      log_hash(method: 'Request#post', url: url, params: params)

      response = with_exception_handling(params) do
        NetClient.post(url, body_parameters(params), headers)
      end

      process_response(response)
    end

    def delete(url, params = {})
      log_hash(method: 'Request#delete', url: url, params: params)

      response = with_exception_handling(params) do
        NetClient.delete(url, headers.merge(query(params)))
      end

      process_response(response)
    end

    def upload(url, content, params = {})
      log_hash(method: 'Request#upload', url: url, params: params, content: 'no logging')

      response = with_exception_handling(params) do
        NetClient.post(
          url, content, headers.merge(query(params)).merge(content_type: 'application/octet-stream')
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
      params.map do |name, value|
        [name, value.is_a?(Array) || value.is_a?(Hash) ? value.to_json : value]
      end.to_h
    end

    def query(params)
      { params: params }
    end

    def headers
      {
        Authorization: "Bearer #{access_token}",
        **optional_headers
      }
    end

    def process_response(response)
      JSON.parse(response.body)
    rescue JSON::ParserError
      response.body
    end

    def with_exception_handling(params)
      response = yield
      if response.code >= 400
        log_response(response)
        raise_with_params(params, response: response.body)
      end
      log(response.to_s)
      response
    rescue NetClient::Exception => e
      original_exception = e.original_exception
      log("#{original_exception.class.name} #{original_exception.message}")
      raise_with_params(params, original_exception: original_exception)
    end

    def log_response(response)
      log_message =
        <<-LOG
          HTTP Code: #{response.code}
          HTTP Body: #{response.body}
      LOG

      log(log_message)
    end

    def raise_with_params(params, response:, original_exception: nil)
      result = MyTargetApi::RequestError.new(params,
                                             response: response,
                                             original_exception: original_exception)
      result.set_backtrace(caller)
      raise result
    end

    def log_hash(hash)
      log(hash.map do |key, value|
        "#{key}: #{value.is_a?(String) ? value : value.inspect}"
      end.join("\n"))
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
