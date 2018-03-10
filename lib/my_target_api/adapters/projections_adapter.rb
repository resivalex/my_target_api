# frozen_string_literal: true

module MyTargetApi
  # TM Projections V2
  module ProjectionsAdapter

    def read_projections(presenter)
      request(:post, '/projection.json', presenter.merge(v: 2))
    end

  end
end
