module MiniCamel
  module ProcessorDefinition
    class Process < Base

      values do
        attribute :fields, [Symbol]
        validates :fields, presence: true

        attribute :with_class, Class
        validates :with_class, presence: true
      end

      def generate_processor(env)
        Processor::Process.new(env: env, fields: fields, with_class: with_class)
      end

    end
  end
end
