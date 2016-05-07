describe "Multiple Routes" do

  class MyTransformer1
    include Virtus.model

    attribute :prefix, String

    def call
      self.class.name
    end
  end

  class MyTransformer2
    include Virtus.model

    attribute :prefix, String

    def call
      [prefix, self.class.name].join(' | ')
    end
  end

  let(:environment) { MiniCamel::Environment.new }

  let(:route_builder_class1) do
    Class.new(MiniCamel::RouteBuilder) do
      def configure
        from(:route1).
          desc("Some description.").
          to(:route2).
          to(:route3).
          wrap_in_dto(:prefix, as: :result).
          extract_result(from: :result)
      end
    end
  end

  let(:route_builder_class2) do
    Class.new(MiniCamel::RouteBuilder) do
      def configure
        from(:route2).
          desc("Some description.").
          mutate(:prefix, with_class: MyTransformer1)
      end
    end
  end

  let(:route_builder_class3) do
    Class.new(MiniCamel::RouteBuilder) do
      def configure
        from(:route3).
          desc("Some description.").
          mutate(:prefix, with_class: MyTransformer2)
      end
    end
  end

  it "should transform the prefix" do
    environment.
      register_route_builder(route_builder_class1.new, route_builder_class2.new, route_builder_class3.new).
      finalize

    exchange = environment.dispatch_route(:route1, with_data: {prefix: "Hello"})

    expect(exchange).to be_success
    expect(exchange.result_or_else({})).to eq MiniCamel::ExchangeResult.new(prefix: "MyTransformer1 | MyTransformer2")
  end

end
