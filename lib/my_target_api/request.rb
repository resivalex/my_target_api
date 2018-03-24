# frozen_string_literal: true

# TM request object
module MyTargetApi
  # requests
  module Request

    API_URI = 'https://target.my.com/'
    SUDO_API_URI = 'https://target.my.com/users/'

    def request(method, path, params = {}, headers = {})
      result = make_request(method, path, params, headers).to_s
      JSON.parse result
    rescue JSON::ParserError => _e
      result
    end

    def make_request(method, path, params = {}, headers = {})
      exec_params = compact(build(method, path, params, headers).merge(log: MyTargetApi.logger))
      response = RestClient::Request.execute(exec_params)
      MyTargetApi.logger << response if MyTargetApi.logger
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

    def compact(hash)
      hash.map do |key, value|
        next nil if value.nil?
        [key, value]
      end.compact.to_h
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

      MyTargetApi.logger << log_message if MyTargetApi.logger
    end

    def build(method, path, params, headers)
      path = build_path(params, path)

      token = params.delete(:token)

      token ? headers.merge!(authorization_header(token)) : params.merge!(client_id_and_secret)

      if method == :get
        get_request(path, params, headers)
      elsif method == :post
        post_request(path, params, headers)
      elsif method == :delete
        delete_request(path, params, headers)
      end
    end

    def build_path(params, path)
      path = get_uri(params) + "api/v#{params.delete(:v) || 1}" + path
      path << '.json' unless path.split('/').last['.']
      path
    end

    def authorization_header(token)
      { Authorization: "Bearer #{token}" }
    end

    def client_id_and_secret
      { client_id: MyTargetApi.client_id, client_secret: MyTargetApi.client_secret }
    end

    def get_request(path, params, headers)
      {
        method: :get,
        url: path,
        headers: headers.merge(params: params)
      }
    end

    def delete_request(path, params, headers)
      {
        method: :delete,
        url: path,
        headers: headers.merge(params: params)
      }
    end

    def post_request(path, params, headers)
      {
        method: :post,
        url: path,
        payload: params[:grant_type] ? params : params.to_json,
        headers: headers
      }
    end

    def get_uri(params)
      user = params.delete(:as_user)
      user ? "#{SUDO_API_URI}#{user}/" : API_URI
    end

  end
end
