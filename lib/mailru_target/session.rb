# frozen_string_literal: true

# see https://target.my.com/doc/api/detailed/

module MailruTarget
  # Target mail session
  class Session

    include MailruTarget::Request

    include MailruTarget::CampaignsAdapter
    include MailruTarget::BannersAdapter
    include MailruTarget::ClientsAdapter
    include MailruTarget::ImagesAdapter
    include MailruTarget::PackagesAdapter
    include MailruTarget::StatisticsAdapter
    include MailruTarget::LocationsAdapter
    include MailruTarget::ServiceAdapter
    include MailruTarget::CountersAdapter
    include MailruTarget::ProjectionsAdapter
    include MailruTarget::RemarketingsAdapter
    include MailruTarget::RemarketingUsersListsAdapter
    include MailruTarget::RemarketingPricelistAdapter
    include MailruTarget::RemarketingVkGroupsAdapter
    include MailruTarget::RemarketingContextPhrases
    include MailruTarget::RemarketingUserGeo
    include MailruTarget::GroupsAdapter
    include MailruTarget::ContentAdapter
    include MailruTarget::UserAdapter

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
