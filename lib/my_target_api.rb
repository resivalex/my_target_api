# frozen_string_literal: true

require 'restclient'
require 'json'
require 'my_target_api/adapters/banners_adapter'
require 'my_target_api/adapters/campaigns_adapter'
require 'my_target_api/adapters/clients_adapter'
require 'my_target_api/adapters/images_adapter'
require 'my_target_api/adapters/packages_adapter'
require 'my_target_api/adapters/statistics_adapter'
require 'my_target_api/adapters/locations_adapter'
require 'my_target_api/adapters/service_adapter'
require 'my_target_api/adapters/counters_adapter'
require 'my_target_api/adapters/remarketing_adapter'
require 'my_target_api/adapters/remarketing_users_list_adapter'
require 'my_target_api/adapters/remarketing_vk_groups_adapter'
require 'my_target_api/adapters/remarketing_context_phrases_adapter'
require 'my_target_api/adapters/remarketing_user_geo_adapter'
require 'my_target_api/adapters/remarketing_pricelist_adapter'
require 'my_target_api/adapters/projections_adapter'
require 'my_target_api/adapters/groups_adapter'
require 'my_target_api/adapters/content_adapter'
require 'my_target_api/adapters/user_adapter'
# Api for target_mail
module MyTargetApi

  autoload :Auth, 'my_target_api/auth'
  autoload :Request, 'my_target_api/request'
  autoload :Session, 'my_target_api/session'

  autoload :ConnectionError,  'my_target_api/errors/connection_error'
  autoload :RequestError,     'my_target_api/errors/request_error'

  class << self

    attr_accessor :client_id, :client_secret, :logger
    attr_writer :scopes

    def scopes
      @scopes || 'read_ads,read_payments,create_ads'
    end

  end

end
