# frozen_string_literal: true

class MyTargetApi
  # Error class
  class ConnectionError < StandardError

    def initialize(exception)
      @exception = exception
    end

    def message
      @exception.message
    end

  end
end
