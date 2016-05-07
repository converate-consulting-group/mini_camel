module MiniCamel
  module Processor
    class WrapInDto < Base

      values do
        attribute :field, Symbol
        attribute :as, Symbol
      end

      def call(exchange)
        exchange.update_context(as => MiniCamel::Dto.new(field => exchange.context_fetch(field)))
      end

    end
  end
end



