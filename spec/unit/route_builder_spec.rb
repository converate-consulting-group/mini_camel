describe MiniCamel::RouteBuilder do

  describe "#configure" do
    it "should raise not implemented error" do
      expect { subject.configure }.to raise_error NotImplementedError
    end
  end

end
