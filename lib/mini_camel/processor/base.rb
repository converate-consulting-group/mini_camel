module MiniCamel
  module Processor
    class Base
      include Virtus.value_object

      attribute :env, Environment

      def call(exchange)
        raise NotImplementedError
      end

    end
  end
end
