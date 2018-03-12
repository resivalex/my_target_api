# frozen_string_literal: true

module MyTargetApi
  # Remarketing resource
  module RemarketingsAdapter

    RESOURCE = 'remarketings'

    def create_remarketing(presenter)
      request(:post, "/#{RESOURCE}.json", presenter)
    end

    def update_remarketing(presenter)
      request(:post, "/#{RESOURCE}/#{presenter.delete(:id)}.json", presenter)
    end

  end
end
