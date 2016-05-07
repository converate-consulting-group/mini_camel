module MiniCamel
  module Processor
    class Produce < Base

      values do
        attribute :field, Symbol
        attribute :with_class, Class
      end

      def call(exchange)
        exchange.update_context(field => with_class.new.call)
      end

    end
  end
end

