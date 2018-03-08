# frozen_string_literal: true

module MailruTarget
  # User geo resource
  module RemarketingUserGeo

    RESOURCE = 'remarketing/user_geo'

    def create_remarketing_user_geo(presenter)
      request(:post, "/#{RESOURCE}.json", presenter.merge(v: 2))
    end

    def update_remarketing_user_geo(presenter)
      request(:post, "/#{RESOURCE}/#{presenter[:id]}.json", presenter.except(:id).merge(v: 2))
    end

    def delete_remarketing_user_geo(user_geo_id)
      request(:delete, "/#{RESOURCE}/#{user_geo_id}.json", v: 2)
    end

  end
end
