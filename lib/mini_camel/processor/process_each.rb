module MiniCamel
  module Processor
    class ProcessEach < Each

      def call(exchange)
        additional_data = fetch_additional_data(exchange)

        # The use of map is no coincidence! (will be used as result in TransformEach)
        fetch_collection(exchange).map do |entry|
          process(entry, additional_data)
        end
      end

    end
  end
end
