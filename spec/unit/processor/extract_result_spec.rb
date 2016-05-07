describe MiniCamel::Processor::ExtractResult do

  describe "#call" do
    let(:from) { :feld }
    let(:exchange) { double(:exchange) }
    let(:result) { double(:result) }
    let(:exchange_result) { double(:exchange_result) }

    subject { described_class.new(from: from) }

    it "should extract the result" do
      expect(exchange).to receive(:context_fetch).with(from).and_return(result)
      expect(result).to receive(:kind_of?).with(MiniCamel::Dto).and_return(true)
      expect(MiniCamel::ExchangeResult).to receive(:new).with(result).and_return(exchange_result)
      expect(exchange).to receive(:set_result).with(exchange_result)

      subject.call(exchange)
    end

    context "when result is not an DTO or a hash" do
      it "should raise an ArgumentError" do
        expect(exchange).to receive(:context_fetch).with(from).and_return(result)
        expect(result).to receive(:kind_of?).with(MiniCamel::Dto).and_return(false)
        expect(result).to receive(:kind_of?).with(Hash).and_return(false)

        expect { subject.call(exchange) }.to raise_error(ArgumentError)
      end
    end
  end

end
