# frozen_string_literal: true

module MyTargetApi
  # adapters for clients
  module ClientsAdapter

    def read_clients(_presenter)
      request(:get, '/clients.json')
    end

    def remarketing_counters_client(_presenter)
      request(:get, '/remarketing/counters.json', v: 2)
    end

    def create_client(presenter)
      request(:post, '/clients.json', presenter)
    end

    def credit_client(presenter)
      request(:post, "/transactions/to/#{presenter.delete(:user)}.json", presenter)
    end

    def debit_client(presenter)
      request(:post, "/transactions/from/#{presenter.delete(:user)}.json", presenter)
    end

    def get_token_client(presenter)
      request(
        :post,
        '/oauth2/token.json',
        presenter.merge(
          grant_type: 'agency_client_credentials',
          v: 2
        )
      )
    end

    def refresh_token_client(presenter)
      request(
        :post,
        '/oauth2/token.json',
        presenter.merge(
          grant_type: 'refresh_token',
          v: 2
        )
      )
    end

  end
end
