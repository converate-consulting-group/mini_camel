describe MiniCamel::Route do

  describe "#call" do
    let(:env) { double(:env, finalized?: true) }
    let(:exchange) { double(:exchange) }
    let(:processor1) { double(:processor1) }
    let(:processor2) { double(:processor2) }
    let(:processors) { [processor1, processor2] }

    it "should call each processor with the given exchange" do
      expect(subject).to receive(:env).and_return(env)
      expect(processor1).to receive(:call).with(exchange)
      expect(processor2).to receive(:call).with(exchange)
      expect(subject).to receive(:processors).and_return(processors)

      subject.call(exchange)
    end
  end

end
