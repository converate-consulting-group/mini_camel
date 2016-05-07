shared_examples 'a dto' do

  let(:key) { :value_key }
  let(:result) { double(:result) }
  subject { described_class.new(key => result) }

  describe ".empty" do
    subject { described_class }
    it "should create an empty dto" do
      expect(subject.empty).to eq described_class.new
    end
  end

  describe "#update" do
    it "should change the dto" do
      expect {
        subject.update(key => "new result")
      }.to change { subject[key] }.from(result).to("new result")
    end
  end

  describe "#to_hash" do
    let(:expected_result) do
      Hash[key.to_s => result]
    end

    it "should return the dto as a hash" do
      expect(subject.to_hash).to eq expected_result
    end
  end

  describe "#to_json" do
    let(:expected_result) do
      Hash[key => result].to_json
    end

    it "should return the dto as json" do
      expect(subject.to_json).to eq expected_result
    end
  end

  describe "#as_json" do
    let(:expected_result) do
      Hash[key => result].as_json
    end

    it "should return the dto as json" do
      expect(subject.as_json).to eq expected_result
    end
  end

  describe "#keys" do
    it "should return the keys" do
      expect(subject.keys).to include key.to_s
    end
  end

end



