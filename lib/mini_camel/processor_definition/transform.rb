module MiniCamel
  module ProcessorDefinition
    class Transform < Process

      values do
        attribute :to, Symbol
        validates :to, presence: true
      end

      def generate_processor(env)
        Processor::Transform.new(env: env, fields: fields, to: to, with_class: with_class)
      end

    end
  end
end

