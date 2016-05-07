module MiniCamel
  module ProcessorDefinition
    class Validate < Base

      values do
        attribute :field, Symbol
        validates :field, presence: true

        attribute :message, String
        validates :message, presence: true

        attribute :raise_error, Class
        validates :raise_error, presence: true
      end

      def generate_processor(env)
        Processor::Validate.new(env: env, field: field, message: message, raise_error: raise_error)
      end

      def message
        @message ||= "'#{field}' is invalid."
      end

    end
  end
end
