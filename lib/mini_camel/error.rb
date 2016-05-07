module MiniCamel

  class CamelError < StandardError; end

  class EnvironmentNotFinalized < CamelError; end

  class InvalidInteractor < CamelError; end

  class InvalidRouteDefinition < CamelError

    attr_reader :route_definition

    def initialize(message, route_definition)
      @route_definition = route_definition
      super("#{message}: #{route_definition.class} #{route_definition.errors.full_messages}")
    end

  end

  class InvalidProcessorDefinition < CamelError

    attr_reader :processor_definition

    def initialize(message, processor_definition)
      @processor_definition = processor_definition
      super("#{message}: #{processor_definition.class} #{processor_definition.errors.full_messages}")
    end

  end

  class ExchangeFailure < CamelError
    attr_reader :exchange_error

    def initialize(message, exchange_error)
      @exchange_error = exchange_error
      super(message)
    end
  end

  class ReRaisedError < CamelError
    attr_reader :original_error_class

    def initialize(message, original_error_class)
      @original_error_class = original_error_class
      super("[#{original_error_class}]: #{message}")
    end
  end

  class UnknownRouteError < CamelError
    attr_reader :route_name

    def initialize(route_name)
      super("Route not found: '#{route_name}'")
    end
  end

end
