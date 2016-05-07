module MiniCamel
  module Processor
    class Validate < Base

      values do
        attribute :field, Symbol

        attribute :message, String

        attribute :raise_error, Class
      end

      def call(exchange)
        value = exchange.context_fetch(field)
        raise raise_error.new(message, value) if value.invalid?
      end

    end
  end
end

