describe MiniCamel::Processor::Pipeline do

  describe "#call" do
    let(:route) { double(:route) }
    let(:routes) { [route] }
    let(:exchange) { double(:exchange) }
    let(:env) { double(:env) }

    subject { described_class.new(routes: routes) }

    it "should call each route" do
      expect(subject).to receive(:env).and_return(env)
      expect(env).to receive(:call_route).with(route, exchange)

      subject.call(exchange)
    end
  end

end

