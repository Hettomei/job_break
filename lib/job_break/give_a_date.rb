require 'date'

module JobBreak
  class GiveADate

    def initialize(date = nil)
      @date = date
    end

    def to_date
      if is_relative?
        Date.today + @date.to_i
      elsif !!@date
        Date.parse(@date)
      else
        Date.today
      end
    end

    private

    def is_relative?
      @date && @date[0] == '-'
    end

  end
end
