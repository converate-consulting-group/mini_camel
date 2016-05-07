module MiniCamel
  module Processor
    class TransformEach < ProcessEach

      values do
        attribute :to, Symbol
      end

      def call(exchange)
        exchange.update_context(to => super)
      end

    end
  end
end
