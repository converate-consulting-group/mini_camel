module MiniCamel
  class RouteDispatcher
    include Virtus.value_object

    attribute :env, Environment

    values do
      attribute :route, Symbol
      attribute :with_data, Object
    end

    def dispatch
      raise EnvironmentNotFinalized, "Please finalize the environment." unless env.finalized?

      exchange = Exchange.new(context: Context.new(with_data))

      env.call_route(route, exchange)

      exchange
    rescue Exception => error
      rescue_error(error, exchange)

      exchange
    end

    private

    def rescue_error(error, exchange)
      error_handler.call(error, exchange)
    end

    def error_handler
      env.error_handler
    end

  end
end
