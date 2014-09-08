require_relative '../spec_helper'
require_relative '../../lib/job_break/pause'

describe JobBreak::Pause do
  let(:epoch_time){ 100000 }
  let(:duration_in_sec){ 100 }
  let(:comment){ nil }
  let(:_break){ JobBreak::Pause.new(epoch_time, duration_in_sec, comment) }

  describe "#negative?" do
    context "duration is positive" do
      it { expect(_break.negative?).to eq false }
    end
    context "duration is negative" do
      let(:duration_in_sec){ -100 }
      it { expect(_break.negative?).to eq true }
    end
  end

  describe "#comment" do
    context "without comment" do
      it { expect(_break.comment).to eq nil }
    end
    context "with a comment" do
      let(:comment){ "salut" }
      it { expect(_break.comment).to eq "salut" }
    end
  end

  describe '#date' do
    it { expect(_break.date).to eq Time.new(1970, 01, 02, 4, 46, 40) }
  end

  describe '#duration' do
    it { expect(_break.duration).to eq Time.new(1970, 01, 01, 1, 1, 40).utc }
  end

end
