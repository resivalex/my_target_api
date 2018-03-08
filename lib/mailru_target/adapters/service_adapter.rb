# frozen_string_literal: true

module MailruTarget
  # adapters for geo and interests
  module ServiceAdapter

    def interests_service(_presenter)
      request(:get, '/interests.json')
    end

    def geo_tree_service(_presenter)
      request(:get, '/geo_tree.json')
    end

    def geo_tree_with_user_geo_service(_presenter)
      request(:get, '/geo_tree_with_user_geo.json')
    end

  end
end
