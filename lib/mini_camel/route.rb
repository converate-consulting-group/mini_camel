module MiniCamel
  class Route
    include Virtus.value_object

    attribute :env, Environment

    values do
      attribute :route_name, Symbol
      attribute :processors, Array, default: []
    end

    def call(exchange)
      raise EnvironmentNotFinalized, "Please finalize the environment." unless env.finalized?

      processors.each do |processor|
        processor.call(exchange)
      end
    end

  end
end
