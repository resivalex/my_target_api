# frozen_string_literal: true

module MailruTarget
  # Adapter to read vk groups
  module GroupsAdapter

    def read_vk_groups(params)
      request(:get, '/vk_groups.json', params)
    end

  end
end
