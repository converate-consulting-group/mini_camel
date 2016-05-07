module MiniCamel
  module Processor
    class Mutate < Base

      values do
        attribute :field, Symbol
        attribute :with_class, Class
      end

      def call(exchange)
        mutation = with_class.new(field => exchange.context_fetch(field)).call
        exchange.update_context(field => mutation)
      end

    end
  end
end

