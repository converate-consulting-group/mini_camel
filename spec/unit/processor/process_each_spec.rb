describe MiniCamel::Processor::ProcessEach do

  describe "#call" do
    let(:additional_data) { double(:additional_data) }
    let(:exchange) { double(:exchange) }
    let(:entry ) { double(:entry) }
    let(:entries) { [entry] }

    subject { described_class.new }

    it "should process an array" do
      expect(subject).to receive(:fetch_additional_data).with(exchange).and_return(additional_data)
      expect(subject).to receive(:fetch_collection).with(exchange).and_return(entries)
      expect(subject).to receive(:process).with(entry, additional_data)

      subject.call(exchange)
    end
  end

end

