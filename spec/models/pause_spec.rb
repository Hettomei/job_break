require_relative '../../models/pause'

describe Pause do
  let(:pause){ Pause.new }

  describe "date" do
    it { expect(pause.date).to eq Date.today }
  end

end
