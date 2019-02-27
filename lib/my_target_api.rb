# frozen_string_literal: true

# MyTargetApi
class MyTargetApi

  API_BASE_URL = 'https://target.my.com/api'

  autoload :Resource, 'my_target_api/resource'
  autoload :Request, 'my_target_api/request'

  autoload :ConnectionError, 'my_target_api/connection_error'
  autoload :RequestError, 'my_target_api/request_error'

  def initialize(access_token, options = {})
    @access_token = access_token
    @options = options
  end

  def resource(path, options = {})
    version = options[:v]
    version_part = version ? "v#{version}" : 'v1'

    Resource.new(self, "#{API_BASE_URL}/#{version_part}/#{path}")
  end

  def get_request(url, params)
    request_object.get(url, params.merge(access_token: access_token))
  end

  def post_request(url, params)
    request_object.post(url, params.merge(access_token: access_token))
  end

  def delete_request(url, params)
    request_object.delete(url, params.merge(access_token: access_token))
  end

  def upload_request(url, content, params)
    request_object.upload(url, content, params.merge(access_token: access_token))
  end

  private

  attr_reader :access_token, :options

  def request_object
    Request.new(logger: options[:logger], access_token: access_token)
  end

end
