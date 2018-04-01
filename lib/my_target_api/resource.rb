# frozen_string_literal: true

class MyTargetApi
  # Reflects api resource
  class Resource

    def initialize(api, path)
      @api = api
      @path = path
    end

    def create(params = {})
      params = prepare_params(params)

      api.post_request("#{path}.json", params)
    end

    def read(params = {})
      params = prepare_params(params)
      id = params.delete(:id)

      if id
        api.get_request("#{path}/#{id}.json", params)
      else
        api.get_request("#{path}.json", params)
      end
    end

    def update(params = {})
      params = prepare_params(params)
      id = params.delete(:id)

      api.post_request("#{path}/#{id}.json", params)
    end

    def delete(params = {})
      params = prepare_params(params)
      id = params.delete(:id)

      api.delete_request("#{path}/#{id}.json", params)
    end

    def resource(relative_path)
      MyTargetApi::Resource.new(api, "#{path}/#{relative_path}")
    end

    private

    attr_reader :api, :path

    def prepare_params(params)
      raise UsingError, 'Params must be a Hash' unless params.is_a? Hash

      params.map do |param, value|
        [param.to_sym, value]
      end.to_h
    end

  end
end
