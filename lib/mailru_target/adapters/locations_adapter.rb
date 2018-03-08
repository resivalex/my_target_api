# frozen_string_literal: true

module MailruTarget
  # adapters for locations
  module LocationsAdapter

    def read_geo_tree_with_user_geo(_presenter)
      request(:get, '/geo_tree_with_user_geo.json')
    end

  end
end
