describe MiniCamel::Processor::ExposeField do

  describe "#call" do
    let(:field) { :feld }
    let(:from) { :from }
    let(:exchange) { double(:exchange) }
    let(:result) { double(:result) }
    let(:exchange_result) { double(:exchange_result) }
    let(:field_value) { double(:field_value) }

    subject { described_class.new(field: field, from: from, as: field) }

    context "when from_value is a hash" do
      let(:value) { double(:value) }
      let(:from_value) { double(:from_value) }

      it "should fetch from the hash" do
        expect(exchange).to receive(:context_fetch).with(from).and_return(from_value)
        expect(from_value).to receive(:is_a?).with(Hash).and_return(true)
        expect(from_value).to receive(:[]).with(field).and_return(field_value)
        expect(exchange).to receive(:update_context).with(field => field_value)

        subject.call(exchange)
      end
    end

    context "when from_value is not a hash" do
      let(:value) { double(:value) }
      let(:from_value) { double(:from_value) }

      it "should fetch from the object" do
        expect(exchange).to receive(:context_fetch).with(from).and_return(from_value)
        expect(from_value).to receive(:is_a?).with(Hash).and_return(false)
        expect(from_value).to receive(:respond_to?).with(field).and_return(true)
        expect(from_value).to receive(:public_send).with(field).and_return(field_value)
        expect(exchange).to receive(:update_context).with(field => field_value)

        subject.call(exchange)
      end

      context "when no method or field is found on the object" do
        it "should throw an ArgumentError" do
          expect(exchange).to receive(:context_fetch).with(from).and_return(from_value)
          expect(from_value).to receive(:is_a?).with(Hash).and_return(false)
          expect(from_value).to receive(:respond_to?).with(field).and_return(false)

          expect { subject.call(exchange) }.to raise_error(ArgumentError)
        end
      end

    end
  end

end
