module MiniCamel
  module Processor
    class To < Base

      values do
        attribute :route, Symbol
      end

      def call(exchange)
        env.call_route(route, exchange)
      end

    end
  end
end
