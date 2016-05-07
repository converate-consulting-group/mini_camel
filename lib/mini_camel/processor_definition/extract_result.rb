module MiniCamel
  module ProcessorDefinition
    class ExtractResult < Base

      values do
        attribute :from, Symbol
        validates :from, presence: true
      end

      def generate_processor(env)
        Processor::ExtractResult.new(env: env, from: from)
      end

    end
  end
end

