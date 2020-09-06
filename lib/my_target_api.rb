# frozen_string_literal: true

# MyTargetApi
class MyTargetApi

  API_BASE_URL = 'https://target.my.com/api'

  autoload :Resource, 'my_target_api/resource'
  autoload :Request, 'my_target_api/request'
  autoload :RequestError, 'my_target_api/request_error'
  autoload :NetClient, 'my_target_api/net_client'
  autoload :LogRequestParametersDecorator, 'my_target_api/log_request_parameters_decorator'

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
    request_object.get(url, params)
  end

  def post_request(url, params)
    request_object.post(url, params)
  end

  def delete_request(url, params)
    request_object.delete(url, params)
  end

  def upload_request(url, content, params)
    request_object.upload(url, content, params)
  end

  private

  attr_reader :access_token, :options

  def request_object
    @_request_object ||= begin
      logger = options[:logger]
      request = Request.new(logger: logger,
                            access_token: access_token,
                            headers: options[:headers] || {})
      LogRequestParametersDecorator.new(request, { logger: logger }.compact)
    end
  end

end
