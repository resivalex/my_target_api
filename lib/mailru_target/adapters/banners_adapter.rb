# frozen_string_literal: true

module MailruTarget
  # adapters for banners
  module BannersAdapter

    def read_campaign_banners(campaign_id)
      request(:get, "/campaigns/#{campaign_id}/banners.json")
    end

    def read_banners(_presenter)
      request(:get, '/banners.json')
    end

    def create_banner(presenter)
      request(:post, "/campaigns/#{presenter.delete(:campaign_id)}/banners.json", presenter)
    end

    def read_banner(id)
      request(:get, "/banners/#{id}.json")
    end

    def update_banner(presenter)
      request(:post, "/banners/#{presenter.delete(:id)}.json", presenter)
    end

  end
end
