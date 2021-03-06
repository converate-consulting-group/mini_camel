module MiniCamel
  module ProcessorDefinition
    class Mutate < Base

      values do
        attribute :field, Symbol
        validates :field, presence: true

        attribute :with_class, Class
        validates :with_class, presence: true
      end


      def generate_processor(env)
        Processor::Mutate.new(env: env, field: field, with_class: with_class)
      end

    end
  end
end

