# frozen_string_literal: true

module MailruTarget
  # adapters for pricelists
  module RemarketingPricelistAdapter

    RESOURCE = 'remarketing_pricelists'

    def read_remarketing_pricelist(_presenter)
      request(:get, "/#{RESOURCE}.json")
    end

    def create_remarketing_pricelist(presenter)
      request(:post, "/#{RESOURCE}.json", presenter)
    end

  end
end
