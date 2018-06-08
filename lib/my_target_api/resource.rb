# frozen_string_literal: true

class MyTargetApi
  # Reflects api resource
  class Resource

    def initialize(api, path)
      @api = api
      @path = path
    end

    def create(params = {})
      with_prepared_params(params) do |prepared|
        api.post_request("#{path}.json", prepared)
      end
    end

    def read(params = {})
      with_prepared_params(params) do |prepared|
        id = prepared.delete(:id)

        if id
          api.get_request("#{path}/#{id}.json", prepared)
        else
          api.get_request("#{path}.json", prepared)
        end
      end
    end

    def update(params = {})
      with_id_and_prepared_params(params) do |id, prepared|
        api.post_request("#{path}/#{id}.json", prepared)
      end
    end

    def delete(params = {})
      with_id_and_prepared_params(params) do |id, prepared|
        api.delete_request("#{path}/#{id}.json", prepared)
      end
    end

    def upload(content, params = {})
      with_prepared_params(params) do |prepared|
        api.upload_request("#{path}.json", content, prepared)
      end
    end

    def resource(relative_path)
      MyTargetApi::Resource.new(api, "#{path}/#{relative_path}")
    end

    private

    attr_reader :api, :path

    def with_prepared_params(params)
      raise ArgumentError, 'Params must be a Hash' unless params.is_a? Hash

      prepared = params.map do |param, value|
        [param.to_sym, value]
      end.to_h

      yield prepared
    end

    def with_id_and_prepared_params(params)
      with_prepared_params(params) do |prepared|
        id = prepared.delete(:id)
        raise ArgumentError, ':id is required' unless id

        yield id, prepared.dup
      end
    end

  end
end
