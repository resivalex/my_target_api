# frozen_string_literal: true

class MyTargetApi
  # Add Authorization header
  class AddAccessTokenToRequestDecorator

    CONTENT_OUTPUT_LIMIT = 1000

    def initialize(origin, access_token: nil)
      @origin = origin
      @access_token = access_token
    end

    def get(url, params = {}, headers = {})
      origin.get(url, params, add_authorization_header(headers))
    end

    def post(url, params = {}, headers = {})
      origin.post(url, params, add_authorization_header(headers))
    end

    def delete(url, params = {}, headers = {})
      origin.delete(url, params, add_authorization_header(headers))
    end

    def upload(url, content, params = {}, headers = {})
      origin.upload(url, content, params, add_authorization_header(headers))
    end

    private

    attr_reader :origin, :access_token

    def add_authorization_header(headers)
      if access_token
        { 'Authorization' => "Bearer #{access_token}" }.merge(headers)
      else
        headers
      end
    end

  end
end
