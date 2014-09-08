module JobBreak
  class Pause

    attr_accessor :comment

    def initialize(epoch_time, duration_sec, comment)
      @epoch_time = epoch_time
      @duration_sec = duration_sec
      @comment = comment
    end

    def date
      @date ||= Time.at(@epoch_time)
    end

    def duration
      @duration ||= Time.at(@duration_sec.abs).utc
    end

    def negative?
      @duration_sec < 0
    end

  end
end
