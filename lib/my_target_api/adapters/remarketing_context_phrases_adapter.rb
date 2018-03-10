# frozen_string_literal: true

module MyTargetApi
  # Context phrases resource
  module RemarketingContextPhrases

    RESOURCE = 'remarketing_context_phrases'

    def create_remarketing_context_phrases(presenter)
      presenter[:file] = File.new(presenter[:file], 'rb')
      # Passing empty grant_type here for params not to be
      # converted into JSON (@see #build method in request.rb)
      request(:post, "/#{RESOURCE}.json", presenter.merge(grant_type: ''))
    end

    def delete_remarketing_context_phrases(phrases_id)
      request(:delete, "/#{RESOURCE}/#{phrases_id}.json")
    end

  end
end
