class Pause

  def initialize(epoch_time, duration_sec)
    @epoch_time = epoch_time
    @duration_sec = duration_sec
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

