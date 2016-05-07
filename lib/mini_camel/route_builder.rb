module MiniCamel
  class RouteBuilder
    include Virtus.value_object

    values do
      attribute :route_collection
    end

    def configure
      raise NotImplementedError
    end

    def route_collection
      @route_collection ||= RouteCollection.new
    end

    private

    def from(route_name)
      route_collection.from(route_name)
    end

  end
end
