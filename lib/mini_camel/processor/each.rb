module MiniCamel
  module Processor
    class Each < Base

      values do
        attribute :field, Symbol
        attribute :in_field, Symbol
        attribute :additional_fields, [Symbol]
        attribute :with_class, Class
      end

      private

      def process(entry, additional_data)
        with_class.new(additional_data.merge(field => entry)).call
      end

      def fetch_additional_data(exchange)
        additional_fields.map{|f| {f => exchange.context_fetch(f)}}.reduce(&:merge) || {}
      end

      def fetch_collection(exchange)
        exchange.context_fetch(in_field)
      end

    end
  end
end
