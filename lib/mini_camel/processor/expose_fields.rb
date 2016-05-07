module MiniCamel
  module Processor
    class ExposeFields < Base

      values do
        attribute :fields, [Symbol]
        attribute :from, Symbol
      end

      def call(exchange)
        from_value  = exchange.context_fetch(from)

        if from_value.is_a?(Hash)
          field_values = map_hash(from_value)
        else
          field_values = map_object(from_value)
        end

        exchange.update_context(field_values || {})
      end

      private

      def map_hash(from_value)
        fields.map{|field| {field => from_value[field]}}.reduce(&:merge)
      end

      def map_object(from_value)
        fields.map{|field| {field => from_value.public_send(field)}}.reduce(&:merge)
      end

    end
  end
end
