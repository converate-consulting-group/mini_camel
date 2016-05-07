module MiniCamel
  module ProcessorDefinition
    class MutateEach < Each

      def generate_processor(env)
        Processor::MutateEach.new(
          env: env, field: field, in_field: in_field, with_class: with_class,
          additional_fields: additional_fields
        )
      end

    end
  end
end

