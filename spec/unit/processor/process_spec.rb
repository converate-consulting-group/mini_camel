describe MiniCamel::Processor::Process do

  describe "#call" do
    let(:field) { double(:field) }
    let(:fields) { [field] }
    let(:exchange) { double(:exchange) }
    let(:with_class) { double(:with_class) }
    let(:visible_fields) { double(:visible_fields) }
    let(:processor_class) { double(:processor_class) }

    subject { described_class.new(fields: fields, with_class: with_class) }

    it "should call each route" do
      expect(subject).to receive(:visible_fields).with(exchange).and_return(visible_fields)
      expect(with_class).to receive(:new).with(visible_fields).and_return(processor_class)
      expect(processor_class).to receive(:call)

      subject.call(exchange)
    end
  end

end

