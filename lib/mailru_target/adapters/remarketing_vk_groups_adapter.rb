# frozen_string_literal: true

module MailruTarget
  # VK groups resource
  module RemarketingVkGroupsAdapter

    RESOURCE = 'remarketing_vk_groups'

    def read_remarketing_vk_groups(_presenter)
      request(:get, "/#{RESOURCE}.json")
    end

    def create_remarketing_vk_group(presenter)
      request(:post, "/#{RESOURCE}.json", presenter)
    end

  end
end
