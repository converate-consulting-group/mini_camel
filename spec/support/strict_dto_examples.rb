shared_examples 'a strict dto' do

  it_should_behave_like 'a dto' do

    describe "#fetch" do
      let(:default) { false }

      context "when key is present" do
        it "should return the key value" do
          expect(subject.fetch(key)).to eq result
        end
      end

      context "when key is present and default value is given" do
        it "should return the key value" do
          expect(subject.fetch(key, default: default)).to eq result
        end
      end

      context "when key value is nil but default value is given" do
        let(:key) { :special }
        let(:result) { nil }

        it "should return the key value" do
          expect(subject.fetch(key, default: default)).to eq result
        end
      end

      context "when key is not present but default value is given" do
        it "should return the default value" do
          expect(subject.fetch(:unknown_key, default: default)).to eq default
        end
      end

      context "when key is not present and no default value is given" do
        it "should raise an argument error" do
          expect { subject.fetch(:unknown_key) }.to raise_error ArgumentError
        end
      end
    end

  end

end



