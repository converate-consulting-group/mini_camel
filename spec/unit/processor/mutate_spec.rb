describe MiniCamel::Processor::Mutate do

  describe "#call" do
    let(:field) { :feld }
    let(:with_class) { double(:class) }
    let(:exchange) { double(:exchange) }
    let(:value) { double(:value) }
    let(:processor) { double(:processor) }
    let(:mutation) { double(:mutation) }

    subject { described_class.new(field: field, with_class: with_class) }

    it "should change the field in the exchange" do
      expect(exchange).to receive(:context_fetch).with(field).and_return(value)
      expect(with_class).to receive(:new).with(field => value).and_return(processor)
      expect(processor).to receive(:call).and_return(mutation)
      expect(exchange).to receive(:update_context).with(field => mutation)

      subject.call(exchange)
    end
  end

end
