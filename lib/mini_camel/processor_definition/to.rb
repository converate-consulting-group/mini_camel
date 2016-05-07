module MiniCamel
  module ProcessorDefinition
    class To < Base

      values do
        attribute :route, Symbol
        validates :route, presence: true
      end

      def generate_processor(env)
        Processor::To.new(env: env, route: route)
      end

    end
  end
end

