class GiveADate

  def initialize(date = nil)
    @date = date
  end

  def to_date
    return @to_date if defined? @to_date

    return @to_date = Date.today unless @date

    return  @to_date = Date.today - relative if is_relative?

    @to_date = Date.parse(@date)
  end

  private

  def is_relative?
    @date[0] == '-'
  end

  def relative
    @date[1..-1].to_i
  end
end
