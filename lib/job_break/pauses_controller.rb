module JobBreak
  class PausesController

    def initialize(date = nil)
      @date = GiveADate.new(date).to_date
    end
    attr_reader :date

    def date_to_sql
      @date_to_sql ||= date.strftime
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
        db.all_pauses(date_to_sql).each do |row|
          pauses << Pause.new(row[0], row[1], row[2])
        end
      end
    end

    def display_all_pauses
      Display.new(all_pauses).all_pauses

      display_break_in_progress
      puts sum_break_plus_in_progress
      display_sum_break
    end

    def add_pause_minutes(minutes, comment = '')
      db.add_pause(minutes*60, comment)
    end

    def del_last
      db.del_all_last
    end

    def show_loop
      Display.new(all_pauses).all_pauses
      display_break_in_progress
      loop do
        begin
          print sum_break_plus_in_progress + "\r"
          $stdout.flush
          sleep 5
        rescue Interrupt
          puts "\nexiting..."
          exit
        end
      end
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
      last_entry = db.last_entry_temp.flatten.first
      last_entry ? Time.at(last_entry) : nil
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

    def sum_break_plus_in_progress
      if sum_break && started?
        I18n.t('pause.total_break_time',
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
end
