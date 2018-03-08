# frozen_string_literal: true

# Counters API methods for TM
module MailruTarget
  # adapters for couners
  module CountersAdapter

    def create_remarketing_counter(data)
      request(:post, '/remarketing/counters.json', data.merge(v: 2))
    end

    def delete_remarketing_counter(data)
      request(:delete, "/remarketing/counters/#{data[:counter_id]}.json", v: 2)
    end

  end
end
