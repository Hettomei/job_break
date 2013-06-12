require_relative '../../models/give_a_date'
require 'date'

describe GiveADate do

  let(:custom_date){ GiveADate.new(a_date) }
  let(:a_date){ nil }

  describe "to_date" do
    context "with nothing given" do
      let(:custom_date){ GiveADate.new }
      it { expect(custom_date.to_date).to eq Date.today }
    end

    context "with a date in string" do
      let(:a_date){ '2012-10-3' }
      it { expect(custom_date.to_date).to eq Date.new(2012,10,3) }
    end

    context "with a relative date back in time" do
      let(:a_date){ '-3' }
      it { expect(custom_date.to_date).to eq(Date.today - 3) }
    end

  end

end
