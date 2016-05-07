describe MiniCamel::RouteDispatcher do

  describe "#dispatch" do
    let(:with_data) { Hash[x: 1] }
    let(:route) { :some_route_name }
    let(:exchange) { MiniCamel::Exchange.new(context: MiniCamel::Context.new(with_data)) }
    let(:env) { double(:env, finalized?: true) }

    subject { described_class.new(route: route, with_data: with_data) }

    context "without errors" do
      it "should call the route and return the exchange" do
        allow(subject).to receive(:env).and_return(env)
        expect(env).to receive(:call_route).with(route, exchange)
        expect(subject.dispatch).to eq exchange
      end
    end

    context "with errors" do
      it "should call the route catch the raised error" do
        allow(subject).to receive(:env).and_return(env)
        expect(env).to receive(:call_route).with(route, exchange).and_raise(RuntimeError)
        expect(subject).to receive(:rescue_error).with(an_instance_of(RuntimeError), exchange)
        expect(subject.dispatch).to eq exchange
      end
    end

  end

end
