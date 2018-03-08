# frozen_string_literal: true

# see https://target.my.com/doc/api/oauth2

module MailruTarget
  # authorization
  class Auth

    class << self

      include MailruTarget::Request

      def authorize_url
        state = (0...32).map { (65 + rand(26)).chr }.join.downcase
        'https://target.my.com/oauth2/authorize?response_type=code' \
          "&client_id=#{MailruTarget.client_id}&state=#{state}&scope=#{MailruTarget.scopes}"
      end

      # We need new method to receive token using `agency_client_credentials` grant type
      # @param client_username [String] client user_name in myTarget
      # @return [Hash] containing requested access_token
      def get_agency_client_credentials(client_username)
        params = { grant_type: 'agency_client_credentials',
                   agency_client_name: client_username,
                   v: 2 }
        request :post, '/oauth2/token', params
      end

      def get_token(code)
        params = { grant_type: 'authorization_code', code: code, v: 2 }
        request :post, '/oauth2/token', params
      end

      def refresh_token(code)
        params = { grant_type: 'refresh_token', refresh_token: code, v: 2 }
        request :post, '/oauth2/token', params
      end

    end

  end
end
