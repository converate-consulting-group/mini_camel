describe MiniCamel::Environment do

  describe "#dispatch_route" do
    let(:result) { double }
    let(:route_name) { :some_route }
    let(:with_data) { double(:with_data) }
    let(:dispatcher) { double(:dispatcher) }

    it "should call the route dispatcher" do
      expect(MiniCamel::RouteDispatcher).to receive(:new).
        with(route: route_name, with_data: with_data, env: subject).
        and_return(dispatcher)

      expect(dispatcher).to receive(:dispatch).and_return(result)

      expect(subject.dispatch_route(route_name, with_data: with_data)).to eq result
    end
  end

  describe "#register_route_builder" do
    let(:route_builder) { double }

    it "should add a route builder" do
      expect {
        subject.register_route_builder(route_builder)
      }.to change { subject.route_builders }.from([]).to([route_builder])
    end
  end

  describe "#add_route" do
    let(:route) { double }

    it "should add a route" do
      expect {
        subject.add_route(route)
      }.to change { subject.routes }.from([]).to([route])
    end
  end

  describe "#finalize" do
    let(:finalizer_class) { double(:finalizer_class) }
    let(:finalizer) { double(:finalizer) }

    it "should finalize the env" do
      allow(subject).to receive(:finalizer_class).and_return(finalizer_class)
      expect(finalizer_class).to receive(:new).with(env: subject).and_return(finalizer)
      expect(finalizer).to receive(:finalize)
      expect(subject.finalize).to eq subject
    end
  end

  describe "#finalized!" do
    specify { expect { subject.finalize }.to change {subject.finalized}.from(false).to(true) }
  end

  describe "#call_route" do
    let(:exchange) { double(:exchange) }
    let(:route) { double(:route) }
    let(:route_hash) { Hash[cool_route: route] }

    it "should call a route by name" do
      expect(subject).to receive(:routes_by_name).and_return(route_hash)
      expect(route).to receive(:call).with(exchange)
      subject.call_route(:cool_route, exchange)
    end
  end

  describe "#finalizer_class" do
    it "should have a default" do
      expect(subject.finalizer_class).to eq MiniCamel::RouteFinalizer
    end
  end

  describe "#error_handler" do
    it "should have a default" do
      expect(subject.error_handler).to eq MiniCamel::DefaultErrorHandler.new
    end
  end

end


