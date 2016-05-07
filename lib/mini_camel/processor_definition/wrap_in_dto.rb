module MiniCamel
  module ProcessorDefinition
    class WrapInDto < Base

      values do
        attribute :field, Symbol
        validates :field, presence: true

        attribute :as, Symbol
        validates :as, presence: true
      end

      def generate_processor(env)
        Processor::WrapInDto.new(env: env, field: field, as: as)
      end

    end
  end
end


