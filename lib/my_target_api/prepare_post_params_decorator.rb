# frozen_string_literal: true

require 'json'

class MyTargetApi
  # Prepare post params
  class PreparePostParamsDecorator

    def initialize(origin)
      @origin = origin
    end

    def get(url, params = {}, headers = {})
      origin.get(url, params, headers)
    end

    def post(url, params = {}, headers = {})
      prepared = body_parameters(params)

      if prepared.is_a?(String)
        origin.upload(url, prepared, {}, { 'Content-Type' => 'application/json' }.merge(headers))
      else
        origin.post(url, prepared, headers)
      end
    end

    def delete(url, params = {}, headers = {})
      origin.delete(url, params, headers)
    end

    def upload(url, content, params = {}, headers = {})
      origin.upload(url, content, params, headers)
    end

    private

    attr_reader :origin

    def body_parameters(params)
      result_params = params.dup

      if result_params.values.any? { |param| param.is_a? IO } || result_params[:grant_type]
        individual_body_parameters(result_params)
      else
        result_params.to_json
      end
    end

    def individual_body_parameters(params)
      params.transform_values do |value|
        value.is_a?(Array) || value.is_a?(Hash) ? value.to_json : value
      end
    end

  end
end
