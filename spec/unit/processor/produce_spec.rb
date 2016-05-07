describe MiniCamel::Processor::Produce do

  describe "#call" do
    let(:field) { double(:field) }
    let(:exchange) { double(:exchange) }
    let(:with_class) { double(:with_class) }
    let(:processor_class) { double(:processor_class) }
    let(:processor_result) { double(:processor_result) }

    subject { described_class.new(field: field, with_class: with_class) }

    it "should call each route" do
      expect(with_class).to receive(:new).and_return(processor_class)
      expect(processor_class).to receive(:call).and_return(processor_result)
      expect(exchange).to receive(:update_context).with(field => processor_result)

      subject.call(exchange)
    end
  end

end

