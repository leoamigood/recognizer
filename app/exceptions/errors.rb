module Errors

  class ValidationException < StandardError
    def initialize(parameter)
      super("Invalid parameter key: #{parameter.first} value: #{parameter.last}")
    end
  end

end
