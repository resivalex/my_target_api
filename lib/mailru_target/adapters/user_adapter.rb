# frozen_string_literal: true

module MailruTarget
  # User api adapter
  module UserAdapter

    def read_user(_presenter)
      request(:get, '/user.json', v: 2)
    end

    def update_user(presenter)
      request(:post, '/user.json', presenter.merge(v: 2))
    end

  end
end
