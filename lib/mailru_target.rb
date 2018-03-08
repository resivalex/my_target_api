# frozen_string_literal: true

require 'restclient'
require 'json'
require 'mailru_target/adapters/banners_adapter'
require 'mailru_target/adapters/campaigns_adapter'
require 'mailru_target/adapters/clients_adapter'
require 'mailru_target/adapters/images_adapter'
require 'mailru_target/adapters/packages_adapter'
require 'mailru_target/adapters/statistics_adapter'
require 'mailru_target/adapters/locations_adapter'
require 'mailru_target/adapters/service_adapter'
require 'mailru_target/adapters/counters_adapter'
require 'mailru_target/adapters/remarketing_adapter'
require 'mailru_target/adapters/remarketing_users_list_adapter'
require 'mailru_target/adapters/remarketing_vk_groups_adapter'
require 'mailru_target/adapters/remarketing_context_phrases_adapter'
require 'mailru_target/adapters/remarketing_user_geo_adapter'
require 'mailru_target/adapters/remarketing_pricelist_adapter'
require 'mailru_target/adapters/projections_adapter'
require 'mailru_target/adapters/groups_adapter'
require 'mailru_target/adapters/content_adapter'
require 'mailru_target/adapters/user_adapter'
# Api for target_mail
module MailruTarget

  autoload :Auth, 'mailru_target/auth'
  autoload :Request, 'mailru_target/request'
  autoload :Session, 'mailru_target/session'

  autoload :ConnectionError,  'mailru_target/errors/connection_error'
  autoload :RequestError,     'mailru_target/errors/request_error'

  class << self

    attr_accessor :client_id, :client_secret, :scopes, :logger

    def scopes
      @scopes || 'read_ads,read_payments,create_ads'
    end

  end

end
