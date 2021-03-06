module JobBreak
  class Display

    def initialize pauses
      @pauses = pauses
    end

    def all_pauses
      @pauses.each do |pause|
        puts display_line(pause)
      end
    end

    def display_line(pause)
      "#{display_date(pause)} -> #{display_duration(pause)} #{pause.comment}"
    end

    def display_date pause
      pause.date.strftime("%Y-%m-%d %H:%M:%S")
    end

    def display_duration pause
      "#{sign(pause)} #{pause.duration.strftime("%H:%M:%S")}"
    end

    def sign(pause)
      if pause.negative?
        '-'
      else
        ' '
      end
    end

  end
end
