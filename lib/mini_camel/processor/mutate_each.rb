module MiniCamel
  module Processor
    class MutateEach < ProcessEach

      def call(exchange)
        additional_data = fetch_additional_data(exchange)

        fetch_collection(exchange).map! do |entry|
          process(entry, additional_data)
        end
      end

    end
  end
end

