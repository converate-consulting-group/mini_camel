module MiniCamel
  module ProcessorDefinition
    class Base
      include Virtus.value_object
      include ActiveModel::Validations

      def generate_processor(env)
        raise NotImplementedError
      end

    end
  end
end
