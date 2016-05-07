module MiniCamel
  module Processor
    class Process < Base

      values do
        attribute :fields, [Symbol]
        attribute :with_class, Class
      end

      def call(exchange)
        with_class.new(visible_fields(exchange)).call
      end

      private

      def visible_fields(exchange)
        fields.map{|f| {f => exchange.context_fetch(f)}}.reduce(&:merge)
      end

    end
  end
end
