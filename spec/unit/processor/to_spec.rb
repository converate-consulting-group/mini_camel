describe MiniCamel::Processor::To do

  describe "#call" do
    let(:route) { double(:route) }
    let(:exchange) { double(:exchange) }
    let(:env) { double(:env) }

    subject { described_class.new(route: route) }

    it "should call the route" do
      expect(subject).to receive(:env).and_return(env)
      expect(env).to receive(:call_route).with(route, exchange)

      subject.call(exchange)
    end
  end

end


