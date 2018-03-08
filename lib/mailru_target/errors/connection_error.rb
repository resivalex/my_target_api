# frozen_string_literal: true

module MailruTarget
  # Error class
  class ConnectionError < StandardError

    def initialize(e)
      @exception = e
    end

    def message
      @exception.message
    end

  end
end
