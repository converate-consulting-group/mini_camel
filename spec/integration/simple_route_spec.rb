describe "Simple Route" do

  class MyTransformer
    include Virtus.model

    attribute :prefix, String

    def call
      "#{prefix}: Hello World"
    end

  end

  let(:environment) { MiniCamel::Environment.new }

  let(:route_builder_class) do
    Class.new(MiniCamel::RouteBuilder) do
      def configure
        from(:route1).
          desc("Some description.").
          transform(:prefix, to: :transformed_prefix, with_class: MyTransformer).
          wrap_in_dto(:transformed_prefix, as: :result).
          extract_result(from: :result)
      end
    end
  end

  it "should transform the prefix" do
    environment.register_route_builder(route_builder_class.new).finalize

    exchange = environment.dispatch_route(:route1, with_data: {prefix: "Test"})
    expect(exchange).to be_success
    expect(exchange.result_or_else({})).to eq MiniCamel::ExchangeResult.new(transformed_prefix: "Test: Hello World")
  end

end
