describe MiniCamel::ExchangeError do

  let(:error_class) { RuntimeError }
  let(:message) { "Invalid data." }
  let(:details) { MiniCamel::Dto.new(field: ['invalid field']) }

  subject { described_class.new(error_class: error_class, message: message, details: details) }

  describe "#on" do

    context "when the error type equals the catched error type" do
      let(:error) { RuntimeError }

      it "should yield the message and the details" do
        expect { |b| subject.on(error, &b) }.to yield_with_args(message, details)
      end
    end

    context "when the error type does not equal the catched error type" do
      let(:error) { MiniCamel::CamelError }

      it "should not yield the message and the details" do
        expect { |b| subject.on(error, &b) }.not_to yield_control
      end
    end

  end

  describe "#raise!" do
    it "should reraise the error" do
      expect {
        subject.raise!
      }.to raise_error MiniCamel::ReRaisedError
    end
  end

  describe "#as_json" do
    it "should return the interaction error as json" do
      expect(subject.as_json).to eq Hash[error_class: 'RuntimeError', message: message, details: details].as_json
    end
  end


end
