describe MiniCamel::Exchange do

  describe "#success?" do

    before :each do
      expect(subject).to receive(:error).and_return(error)
    end

    context "when there is an error" do
      let(:error) { double }

      it "should return false" do
        expect(subject.success?).to be_falsy
      end
    end

    context "when there is no error" do
      let(:error) { nil }

      it "should return true" do
        expect(subject.success?).to be_truthy
      end
    end

  end

  describe "#failure?" do
    before :each do
      expect(subject).to receive(:success?).and_return(success)
    end

    context "when no error is present" do
      let(:success) { true }

      it "should return false" do
        expect(subject.failure?).to be_falsy
      end
    end

    context "when an error is present" do
      let(:success) { false }

      it "should return true" do
        expect(subject.failure?).to be_truthy
      end
    end
  end

  describe "#on" do
    context "with invalid callback modifier" do
      it "should throw an argument error" do
        expect { subject.on(:wrong_modifier) }.to raise_error ArgumentError
      end
    end

    context "with valid callback modifier" do
      let(:data) { double(:data) }

      before :each do
        expect(subject).to receive(:error).and_return(error)
        allow(subject).to receive(:data).and_return(data)
      end

      context "when success modifier is given" do
        let(:result) { double }

        context "and there are no errors" do
          let(:error) { nil }

          it "should yield the result" do
            expect(subject).to receive(:result).and_return(result)
            expect { |b| subject.on(:success, &b) }.to yield_with_args(result)
          end
        end

        context "and there are errors" do
          let(:error) { double }

          it "should not yield the result" do
            expect { |b| subject.on(:success, &b) }.not_to yield_with_args(result)
          end
        end
      end

      context "when failure modifier is given" do
        let(:error) { MiniCamel::ExchangeError.new(error: double, message: 'test') }

        context "and there are errors" do

          it "should yield the interaction error and the interaction data" do
            allow(subject).to receive(:error).and_return(error)

            expect { |b| subject.on(:failure, &b) }.to yield_with_args(error)
          end
        end

        context "and there are no errors" do
          let(:error) { nil }

          it "should not yield the interaction error" do
            expect { |b| subject.on(:failure, &b) }.not_to yield_control
          end
        end
      end

    end

  end

  describe "#update_context" do
    let(:result) { double(:result) }
    let(:error) { double(:error) }
    let(:context) { double(:context) }

    it "should modify the interaction data" do
      expect(subject).to receive(:context).and_return(context)
      expect(context).to receive(:update).with(test: "data")

      subject.update_context(test: "data")
    end
  end

  describe "#context_fetch!" do
    let(:field_name) { :name }
    let(:context) { double(:context) }
    let(:default) { double(:default) }

    it "should fetch data" do
      expect(subject).to receive(:context).and_return(context)
      expect(context).to receive(:fetch).with(field_name, default: default)

      subject.context_fetch(field_name, default: default)
    end

  end

  describe "#result_or_else" do
    let(:result) { double }

    before :each do
      expect(subject).to receive(:success?).and_return(success)
    end

    context "on success" do
      let(:success) { true }

      it "should return the exchange result" do
        expect(subject).to receive(:result).and_return(result)
        expect(subject.result_or_else({})).to eq result
      end
    end

    context "on failure" do
      let(:success) { false }

      it "should return the fallback" do
        expect(subject.result_or_else({moin: 1})).to eq MiniCamel::ExchangeResult.new(moin: 1)
      end
    end
  end

  describe "#result_or_else_try" do
    let(:result) { double }

    before :each do
      expect(subject).to receive(:success?).and_return(success)
    end

    context "on success" do
      let(:success) { true }

      it "should return the exchange result" do
        expect(subject).to receive(:result).and_return(result)
        expect(subject.result_or_else_try).to eq result
      end
    end

    context "on failure" do
      let(:success) { false }

      it "should yield" do
        expect { |b| subject.result_or_else_try(&b) }.to yield_control
      end
    end
  end

  describe "#result_or_else_fail!" do
    let(:result) { double }

    before :each do
      expect(subject).to receive(:success?).and_return(success)
    end

    context "on success" do
      let(:success) { true }

      it "should return the exchange result" do
        expect(subject).to receive(:result).and_return(result)
        expect(subject.result_or_else_fail!).to eq result
      end
    end

    context "on failure" do
      let(:success) { false }

      it "should yield" do
        expect { subject.result_or_else_fail! }.to raise_error MiniCamel::ExchangeFailure
      end
    end
  end

end

