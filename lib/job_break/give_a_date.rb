require 'adamantium'
require 'date'

module JobBreak
  class GiveADate

    include Adamantium

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
    memoize :to_date

    private

    def is_relative?
      @date && @date[0] == '-'
    end

  end
end
