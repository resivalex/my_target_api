# frozen_string_literal: true

# see https://target.my.com/doc/api/detailed/

module MyTargetApi
  # Target mail session
  class Session

    include MyTargetApi::Request

    include MyTargetApi::CampaignsAdapter
    include MyTargetApi::BannersAdapter
    include MyTargetApi::ClientsAdapter
    include MyTargetApi::ImagesAdapter
    include MyTargetApi::PackagesAdapter
    include MyTargetApi::StatisticsAdapter
    include MyTargetApi::LocationsAdapter
    include MyTargetApi::ServiceAdapter
    include MyTargetApi::CountersAdapter
    include MyTargetApi::ProjectionsAdapter
    include MyTargetApi::RemarketingsAdapter
    include MyTargetApi::RemarketingUsersListsAdapter
    include MyTargetApi::RemarketingPricelistAdapter
    include MyTargetApi::RemarketingVkGroupsAdapter
    include MyTargetApi::RemarketingContextPhrases
    include MyTargetApi::RemarketingUserGeo
    include MyTargetApi::GroupsAdapter
    include MyTargetApi::ContentAdapter
    include MyTargetApi::UserAdapter

    attr_accessor :token

    def initialize(token)
      @token = token
    end

    def request(method, path, params = {})
      super method, path, params.merge(token: token)
    end

    def call(method, action, params = {})
      if respond_to?("#{action}_#{method}")
        send("#{action}_#{method}", params)
      else
        Rails.logger.info '[ERROR] Called undefined myTarget API method or entity'\
                          " '#{action}_#{method}' with params: #{params}"
        false
      end
    end

  end
end
