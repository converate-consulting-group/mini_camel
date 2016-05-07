describe MiniCamel::RouteGenerator do

  describe "#generate_route" do
    let(:route_definition) { double(:route_definition, route_name: "route_name") }
    let(:generated_processors) { double(:generated_processors) }
    let(:result) { double(:result) }
    let(:env) { double(:env) }

    subject { described_class.new(route_definition: route_definition) }

    it "should generate a route" do
      expect(subject).to receive(:generate_processors).and_return(generated_processors)
      expect(subject).to receive(:env).and_return(env)
      expect(route_definition).to receive(:invalid?).and_return(false)

      expect(MiniCamel::Route).to receive(:new).
        with(route_name: "route_name", processors: generated_processors, env: env).
        and_return(result)

      expect(subject.generate_route).to eq result
    end
  end

end
