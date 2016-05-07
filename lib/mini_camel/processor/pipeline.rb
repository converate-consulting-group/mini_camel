module MiniCamel
  module Processor
    class Pipeline < Base

      values do
        attribute :routes, [Symbol]
      end

      def call(exchange)
        routes.each do |route|
          env.call_route(route, exchange)
        end
      end

    end
  end
end


