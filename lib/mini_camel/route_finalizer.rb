module MiniCamel
  class RouteFinalizer
    include Virtus.value_object

    attribute :env, Environment

    values do
      attribute :route_generator_class, Class
    end

    def finalize
      env.route_builders.each(&:configure)

      route_collections = env.route_builders.map(&:route_collection)

      route_collections.each do |route_collection|
        route_definitions = route_collection.routes

        route_definitions.each do |route_definition|
          env.add_route(generate_route(route_definition))
        end
      end

      env.finalized!
    end

    def route_generator_class
      @route_generator_class ||= RouteGenerator
    end

    private

    def generate_route(route_definition)
      route_generator_class.new(env: env, route_definition: route_definition).generate_route
    end

  end
end
