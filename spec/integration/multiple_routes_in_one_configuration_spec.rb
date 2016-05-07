describe "Multiple Routes In One Configuration" do

  class M1
    include Virtus.model

    attribute :prefix, String

    def call
      [prefix, self.class.name].join(' | ')
    end
  end

  class M2 < M1; end
  class M3 < M1; end
  class M4 < M1; end

  let(:environment) { MiniCamel::Environment.new }

  let(:route_builder_class1) do
    Class.new(MiniCamel::RouteBuilder) do
      def configure
        from(:route1).
          desc("Some description").
          pipeline(:route2, :route3, :route4).
          wrap_in_dto(:prefix, as: :result).
          extract_result(from: :result)

        from(:route2).
          desc("Some description").
          mutate(:prefix, with_class: M1)

        from(:route3).
          desc("Some description.").
          mutate(:prefix, with_class: M2)

        from(:route4).
          desc("Some description.").
          mutate(:prefix, with_class: M3).
          mutate(:prefix, with_class: M4)
      end
    end
  end

  it "should transform the prefix" do
    environment.register_route_builder(route_builder_class1.new).finalize
    exchange = environment.dispatch_route(:route1, with_data: {prefix: "Hello"})

    expect(exchange).to be_success
    expect(exchange.result_or_else({})).to eq MiniCamel::ExchangeResult.new(prefix: "Hello | M1 | M2 | M3 | M4")
  end

end

