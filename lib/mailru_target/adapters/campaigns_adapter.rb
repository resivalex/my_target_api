# frozen_string_literal: true

module MailruTarget
  # Campaign resource
  module CampaignsAdapter

    RESOURCE = 'campaigns'

    def read_campaigns(_presenter)
      request(:get, "/#{RESOURCE}.json")
    end

    def create_campaign(presenter)
      request(:post, "/#{RESOURCE}.json", presenter)
    end

    def read_campaign(id)
      request(:get, "/#{RESOURCE}/#{id}.json")
    end

    def update_campaign(presenter)
      request(:post, "/#{RESOURCE}/#{presenter.delete(:id)}.json", presenter)
    end

  end
end
