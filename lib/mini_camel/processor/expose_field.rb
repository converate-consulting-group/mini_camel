module MiniCamel
  module Processor
    class ExposeField < Base

      values do
        attribute :field, Symbol
        attribute :from, Symbol
        attribute :as, Symbol
      end

      def call(exchange)
        from_value  = exchange.context_fetch(from)

        if from_value.is_a?(Hash)
          field_value = from_value[field]
        else
          if !from_value.respond_to?(field)
            raise ArgumentError, "#{from} does not respond to #{field}"
          end

          field_value = from_value.public_send(field)
        end

        exchange.update_context(as => field_value)
      end

    end
  end
end
