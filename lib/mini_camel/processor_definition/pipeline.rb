module MiniCamel
  module ProcessorDefinition
    class Pipeline < Base

      values do
        attribute :routes, [Symbol]
        validates :routes, presence: true
      end

      def generate_processor(env)
        Processor::Pipeline.new(env: env, routes: routes)
      end

    end
  end
end

