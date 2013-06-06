class Pause

  def initialize(epoch_time, duration_sec)
    @epoch_time = epoch_time
    @duration_sec = duration_sec
  end

  def line
    "#{display_date} -> #{display_duration}"
  end

  private

  def sign
    if @duration_sec < 0
      '-'
    else
      ' '
    end
  end

  def time
    @time ||= Time.at(@epoch_time)
  end

  def duration
    @duration ||= Time.at(@duration_sec.abs).utc
  end

  def display_date
    #todo : convert with I18n
    @display_date ||= time.strftime("%Y/%m/%d")
  end

  def display_duration
    @display_duration ||= "#{sign} #{duration.strftime("%H:%M:%S")}"
  end

end

