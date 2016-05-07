describe "Unknown Route" do


  let(:environment) { MiniCamel::Environment.new }

  let(:route_builder_class) do
    Class.new(MiniCamel::RouteBuilder) do
      def configure
        from(:route1).
          desc("Some description.").
          to(:unkown)
      end
    end
  end

  it "should raise an error" do
    environment.register_route_builder(route_builder_class.new).finalize

    expect {
      environment.dispatch_route(:route1, with_data: {prefix: "Test"})
    }.to raise_error(MiniCamel::UnknownRouteError, "Route not found: 'unkown'")
  end

end
