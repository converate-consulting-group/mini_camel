module MiniCamel
  module Processor
    class ExtractResult < Base

      values do
        attribute :from, Symbol
      end

      def call(exchange)
        result = exchange.context_fetch(from)

        unless result.kind_of?(MiniCamel::Dto) || result.kind_of?(Hash)
          raise ArgumentError, "Extracted result is not a DTO or a hash!"
        end

        exchange_result = ExchangeResult.new(result)
        exchange.set_result(exchange_result)
      end

    end
  end
end
