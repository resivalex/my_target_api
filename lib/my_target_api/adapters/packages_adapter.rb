# frozen_string_literal: true

module MyTargetApi
  # adapters for packages
  module PackagesAdapter

    def read_packages(_presenter)
      request(:get, '/packages.json', v: 2)
    end

  end
end
