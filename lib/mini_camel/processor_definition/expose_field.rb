module MiniCamel
  module ProcessorDefinition
    class ExposeField < Base

      values do
        attribute :field, Symbol
        validates :field, presence: true

        attribute :from, Symbol
        validates :from, presence: true

        attribute :as, Symbol, default: :default_as
        validates :as, presence: true
      end

      def generate_processor(env)
        Processor::ExposeField.new(env: env, field: field, from: from, as: as)
      end

      private

      def default_as
        field
      end

    end
  end
end
