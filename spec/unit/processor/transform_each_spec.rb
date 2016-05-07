describe MiniCamel::Processor::TransformEach do

  describe "#call" do
    let(:additional_data) { double(:additional_data) }
    let(:exchange) { double(:exchange) }
    let(:entry ) { double(:entry) }
    let(:entries) { [entry] }
    let(:to) { :to_feld }
    let(:processor_result) { double(:processor_result) }

    subject { described_class.new(to: to) }

    it "should process an array" do
      expect(subject).to receive(:fetch_additional_data).with(exchange).and_return(additional_data)
      expect(subject).to receive(:fetch_collection).with(exchange).and_return(entries)
      expect(subject).to receive(:process).with(entry, additional_data).and_return(processor_result)
      expect(exchange).to receive(:update_context).with(to => [processor_result])

      subject.call(exchange)
    end
  end

end

