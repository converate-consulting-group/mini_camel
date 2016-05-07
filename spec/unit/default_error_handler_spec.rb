describe MiniCamel::DefaultErrorHandler do

  describe "#call" do

    let(:exchange) { MiniCamel::Exchange.new }
    subject { described_class.new(error: error, exchange: exchange, registered_errors: registered_errors) }

    context "with known error" do
      let(:error) { MiniCamel::CamelError.new }
      let(:internal_errors) { Hash[stuff: 1] }

      let(:registered_errors) { [error.class] }

      let(:expected_result) do
        MiniCamel::ExchangeError.new(
          error_class: error.class, message: error.message,
          details: MiniCamel::Dto.new(internal_errors), backtrace: []
        )
      end

      it "should set the error on the exchange" do
        expect(error).to receive(:internal_errors).and_return(internal_errors)
        expect(exchange).to receive(:set_error).with(expected_result)
        subject.call(error, exchange)
      end
    end

    context "with unknown error" do
      let(:registered_errors) { [] }
      let(:exchange) { double(:exchange) }
      let(:error) { RuntimeError.new("some error message") }

      it "should raise the error" do
        expect { subject.call(error, exchange) }.to raise_error error
      end
    end
  end

end

