describe MiniCamel::RouteDefinition do

  describe "#from" do
    specify { expect { subject.from("some_route") }.to change { subject.route_name }.from(nil).to(:some_route) }
  end

  describe "#to" do
    let(:expected_result) { MiniCamel::ProcessorDefinition::To.new(route: "some_route") }

    it "should add the processor definition" do
      expect {
        subject.to("some_route")
      }.to change { subject.processor_definitions }.from([]).to([expected_result])
    end
  end

  describe "#process" do
    let(:expected_result) { MiniCamel::ProcessorDefinition::Process.new }

    it "should add the processor definition" do
      expect {
        subject.process
      }.to change { subject.processor_definitions }.from([]).to([expected_result])
    end
  end

  describe "#transform" do
    let(:expected_result) { MiniCamel::ProcessorDefinition::Transform.new }

    it "should add the processor definition" do
      expect {
        subject.transform
      }.to change { subject.processor_definitions }.from([]).to([expected_result])
    end
  end

  describe "#expose_field" do
    let(:expected_result) { MiniCamel::ProcessorDefinition::ExposeField.new(field: :test, from: :hello) }

    it "should add the processor definition" do
      expect {
        subject.expose_field(:test, from: :hello)
      }.to change { subject.processor_definitions }.from([]).to([expected_result])
    end
  end

  describe "#extract_result" do
    let(:expected_result) { MiniCamel::ProcessorDefinition::ExtractResult.new }

    it "should add the processor definition" do
      expect {
        subject.extract_result
      }.to change { subject.processor_definitions }.from([]).to([expected_result])
    end
  end

  describe "#add_processor_definition" do
    let(:expected_result) { MiniCamel::ProcessorDefinition::ExtractResult.new }

    it "should add the processor definition" do
      expect {
        subject.add_processor_definition(expected_result)
      }.to change { subject.processor_definitions }.from([]).to([expected_result])
    end
  end

end
