describe MiniCamel::RouteCollection do

  describe "#from" do
    let(:expected_result) { [MiniCamel::RouteDefinition.new(route_name: "some_route")] }

    it "should generate a route definition and add it to the routes" do
      expect { subject.from("some_route") }.to change { subject.routes }.from([]).to(expected_result)
    end
  end

end
