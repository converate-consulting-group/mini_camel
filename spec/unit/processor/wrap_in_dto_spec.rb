describe MiniCamel::Processor::WrapInDto do

  describe "#call" do
    let(:field) { :feld }
    let(:as) { :as_feld }
    let(:exchange) { double(:exchange) }
    let(:result) { double(:result) }

    subject { described_class.new(field: field, as: as) }

    it "should wrap a field" do
      expect(exchange).to receive(:context_fetch).with(field).and_return(result)
      expect(exchange).to receive(:update_context).with(as => MiniCamel::Dto.new(field => result))

      subject.call(exchange)
    end
  end

end


