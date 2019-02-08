# frozen_string_literal: true

class MyTargetApi
  # Error class
  class ConnectionError < StandardError

    attr_reader :original_exception

    def initialize(exception)
      @original_exception = exception
      @exception = exception
    end

    def message
      @exception.message
    end

  end
end
