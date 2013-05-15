require_relative 'database'
require_relative 'break'

class Pause

  def start_or_end_pause
    unless started?
      start_pause
    else
      end_pause
    end
  end

  def all_pauses(date)
    [].tap do |pauses|
      db.all_pauses(date).each do |day|
        pauses << Break.new(day[0], day[1])
      end
    end
  end

  def display_all_pause_of_this_day(date = 'now')

    all_pauses(date).each do |pause|
      puts pause.line
    end

    sum = db.sum_all_pauses(date)
    if started?
      puts I18n.t('pause.current_break',
                  :time => Time.at(last_entry_time).strftime("%H:%M:%S"),
                  :last => Time.at(Time.now - last_entry_time).utc.strftime("%H:%M:%S")
                 )
      unless sum.flatten.compact.empty?
        puts I18n.t('pause.total_break_time',
                   :time => Time.at((Time.now - last_entry_time) + sum.flatten.first).utc.strftime("%H:%M:%S"))
      end
    else
      unless sum.flatten.compact.empty?
        puts I18n.t('pause.total_break_time',
                    :time => Time.at(sum.flatten.first).utc.strftime("%H:%M:%S"))
      end
    end
  end

  def add_pause_minutes(minutes)
    db.add_pause(minutes*60)
  end

  def display_help
    8.times do |n|
      puts I18n.t("pause.help.text0#{n+1}")
    end
  end

  private

  def db
    @db ||= Database.new
  end

  def started?
    !!last_entry_time
  end

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
    display_all_pause_of_this_day
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
    display_all_pause_of_this_day
  end

end
