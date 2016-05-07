module MiniCamel
  class RouteGenerator
    include Virtus.value_object

    attribute :env, Environment

    values do
      attribute :route_definition, Object
    end

    def generate_route
      raise InvalidRouteDefinition.new("Route #{route_definition.route_name}", route_definition) if route_definition.invalid?

      Route.new(route_name: route_definition.route_name, processors: generate_processors, env: env)
    end

    private

    def generate_processors
      processor_definitions.map do |processor_definition|
        raise InvalidProcessorDefinition.new("Invalid processor definition found", processor_definition) if processor_definition.invalid?

        processor_definition.generate_processor(env)
      end
    end

    def processor_definitions
      route_definition.processor_definitions
    end

  end
end
