require_relative '../../controllers/pauses_controller'

describe PausesController do
  let(:pause){ PausesController.new }

  describe "date" do
    it { expect(pause.date).to eq Date.today }
  end

end
