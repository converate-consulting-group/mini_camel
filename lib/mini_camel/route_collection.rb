module MiniCamel
  class RouteCollection
    include Virtus.value_object

    values do
      attribute :routes, Array, default: []
    end

    def from(route_name)
      route_definition = RouteDefinition.new(route_name: route_name)
      routes << route_definition
      route_definition
    end

  end
end
