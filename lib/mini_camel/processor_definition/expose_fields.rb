module MiniCamel
  module ProcessorDefinition
    class ExposeFields < Base

      values do
        attribute :fields, [Symbol]
        validates :fields, presence: true

        attribute :from, Symbol
        validates :from, presence: true
      end

      def generate_processor(env)
        Processor::ExposeFields.new(env: env, fields: fields, from: from)
      end

    end
  end
end
