module MiniCamel
  module ProcessorDefinition
    class TransformEach < ProcessEach

      values do
        attribute :to, Symbol
        validates :to, presence: true
      end

      def generate_processor(env)
        Processor::TransformEach.new(
          env: env, field: field, in_field: in_field, with_class: with_class,
          additional_fields: additional_fields, to: to
        )
      end

    end
  end
end

