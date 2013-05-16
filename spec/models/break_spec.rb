require_relative '../../models/break'

describe Break do
  let(:breaka){ Break.new(100000, 100) }

  let(:time){ Time.new() }

  describe "line" do
    it "should return a comprehensible line" do
      expect(breaka.line).to eq '1970/01/02 ->   00:01:40'
    end
  end

end
