# frozen_string_literal: true

# MyTargetApi
class MyTargetApi

  API_BASE_URL = 'https://target.my.com/api'

  autoload :Resource, 'my_target_api/resource'
  autoload :Request, 'my_target_api/request'
  autoload :RequestError, 'my_target_api/request_error'
  autoload :NetClient, 'my_target_api/net_client'
  autoload :LogRequestParametersDecorator, 'my_target_api/log_request_parameters_decorator'
  autoload :AddAccessTokenToRequestDecorator, 'my_target_api/add_access_token_to_request_decorator'
  autoload :PreparePostParamsDecorator, 'my_target_api/prepare_post_params_decorator'

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
    request_object.get(url, params, headers)
  end

  def post_request(url, params)
    request_object.post(url, params, headers)
  end

  def delete_request(url, params)
    request_object.delete(url, params, headers)
  end

  def upload_request(url, content, params)
    request_object.upload(url, content, params, headers)
  end

  private

  attr_reader :access_token, :options

  def request_object
    @_request_object ||= begin
      logger = options[:logger]
      request = Request.new(logger: logger)
      request = LogRequestParametersDecorator.new(request, { logger: logger }.compact)
      request = AddAccessTokenToRequestDecorator.new(request, { access_token: access_token })
      PreparePostParamsDecorator.new(request)
    end
  end

  def headers
    options[:headers] || {}
  end

end
