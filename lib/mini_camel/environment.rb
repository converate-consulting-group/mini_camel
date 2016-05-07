module MiniCamel
  class Environment
    include Virtus.value_object

    values do
      attribute :route_builders, Array, default: []
      attribute :routes, Array, default: []
      attribute :finalized, Boolean, default: false

      attribute :finalizer_class, Class
      attribute :error_handler, Object
    end

    def dispatch_route(route_name, options = {})
      with_data = options[:with_data] || Dto.new
      RouteDispatcher.new(route: route_name, with_data: with_data, env: self).dispatch
    end

    def register_route_builder(*builders)
      @route_builders += builders
      self
    end

    def register_error_handler(handler)
      @error_handler = handler
      self
    end

    def add_route(route)
      routes << route
    end

    def finalize
      finalizer_class.new(env: self).finalize
      self
    end

    def finalized!
      @finalized = true
    end

    # @internal
    def call_route(route_name, exchange)
      if route = routes_by_name[route_name]
        route.call(exchange)
      else
        raise UnknownRouteError, route_name
      end
    end

    def finalizer_class
      @finalizer_class ||= RouteFinalizer
    end

    def error_handler
      @error_handler ||= DefaultErrorHandler.new
    end

    private

    def routes_by_name
      @routes_by_name ||= routes.index_by(&:route_name)
    end

  end
end
