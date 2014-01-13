require_relative '../lib/job_break/pauses_controller'

describe JobBreak::PausesController do
  let(:pause){ JobBreak::PausesController.new }

  describe "date" do
    it { expect(pause.date).to eq Date.today }
  end

end
