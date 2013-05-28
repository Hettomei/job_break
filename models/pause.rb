require_relative 'database'
require_relative 'break'

class Pause

  def initialize(date = nil)
    if date
      @date ||= Date.parse(date)
    else
      @date = Time.now.to_date
    end
  end

  def date
    @date
  end

  def date_to_sql
    @date_to_sql ||= @date.strftime
  end

  def start_or_end_pause
    unless started?
      start_pause
    else
      end_pause
    end
  end

  def all_pauses
    [].tap do |pauses|
      db.all_pauses(date_to_sql).each do |day|
        pauses << Break.new(day[0], day[1])
      end
    end
  end

  def display_all_pauses

    all_pauses.each do |pause|
      puts pause.line
    end

    display_break_in_progress
    display_sum_break_plus_in_progress
    display_sum_break
  end

  def add_pause_minutes(minutes)
    db.add_pause(minutes*60)
  end

  private

  def db
    @db ||= Database.new
  end

  def started?
    !!last_entry_time
  end

  #currently, can't be memoized
  def last_entry_time
    last_entry = db.last_entry_temp
    if last_entry.empty?
      return nil
    else
      return Time.at(last_entry.flatten.first)
    end
  end

  def start_pause
    start_time = Time.now
    display_all_pauses
    puts I18n.t('pause.starting_break', :time => start_time.to_s)
    db.insert_time_temp start_time
  end

  def end_pause
    end_time = Time.now
    puts I18n.t('pause.ending_break',
                :time => end_time.strftime("%H:%M:%S"))
    puts I18n.t('pause.duration_break',
                :time => Time.at(end_time - last_entry_time).utc.strftime("%H:%M:%S"))

    db.add_pause(end_time - last_entry_time)
    db.delete_temp_values
    display_all_pauses
  end

  def sum_break
    @sum_break ||= db.sum_all_pauses(date_to_sql).flatten.compact.first
  end

  def display_break_in_progress
    if started?
      puts I18n.t('pause.current_break',
                  :time => Time.at(last_entry_time).strftime("%H:%M:%S"),
                  :last => Time.at(Time.now - last_entry_time).utc.strftime("%H:%M:%S")
                 )
    end
  end

  def display_sum_break_plus_in_progress
    if sum_break && started?
      puts I18n.t('pause.total_break_time',
                  :time => Time.at((Time.now - last_entry_time) + sum_break).utc.strftime("%H:%M:%S"))
    end
  end

  def display_sum_break
    if sum_break && !started?
      puts I18n.t('pause.total_break_time',
                  :time => Time.at(sum_break).utc.strftime("%H:%M:%S"))
    end
  end
end
