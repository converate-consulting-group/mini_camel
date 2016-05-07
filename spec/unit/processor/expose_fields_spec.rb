describe MiniCamel::Processor::ExposeFields do

  describe "#call" do
    let(:field) { :feld }
    let(:fields) { [field] }
    let(:from) { :from }
    let(:exchange) { double(:exchange) }
    let(:result) { double(:result) }
    let(:exchange_result) { double(:exchange_result) }
    let(:field_values) { double(:field_values) }

    subject { described_class.new(from: from) }

    context "when from_value is a hash" do
      let(:value) { double(:value) }
      let(:from_value) { double(:from_value) }

      it "should fetch from the hash" do
        expect(exchange).to receive(:context_fetch).with(from).and_return(from_value)
        expect(from_value).to receive(:is_a?).with(Hash).and_return(true)
        expect(subject).to receive(:map_hash).with(from_value).and_return(field_values)
        expect(exchange).to receive(:update_context).with(field_values)

        subject.call(exchange)
      end
    end

    context "when from_value is not a hash" do
      let(:value) { double(:value) }
      let(:from_value) { double(:from_value) }

      it "should fetch from the object" do
        expect(exchange).to receive(:context_fetch).with(from).and_return(from_value)
        expect(from_value).to receive(:is_a?).with(Hash).and_return(false)
        expect(subject).to receive(:map_object).with(from_value).and_return(field_values)
        expect(exchange).to receive(:update_context).with(field_values)

        subject.call(exchange)
      end
    end
  end

end
