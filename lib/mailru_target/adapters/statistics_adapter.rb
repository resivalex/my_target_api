# frozen_string_literal: true

module MailruTarget
  # adapters for statistics
  module StatisticsAdapter

    def read_statistics(params)
      object_type = params[:object_type]
      object_id = params[:object_ids].join(';')
      stat_type = 'day'
      date_from = params[:date_from]
      date_to = params[:date_to]
      url = "/statistics/#{object_type}/#{object_id}/#{stat_type}/#{date_from}-#{date_to}.json"
      request(:get, url)
    end

  end
end
