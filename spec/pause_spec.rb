require_relative '../pause'

describe Pause do
  it "should be true" do
    Pause.new.the_truth.should eq true
  end
end
