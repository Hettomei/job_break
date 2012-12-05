#encoding : utf-8
##
#How to create sqlite3 table :
#
#$: gem install sqlite3
#$: sqlite3 pause ##pause is the database name
#> create table pauses(day datetime,  duration int);
#> create table temp(start_time datetime);

##
#How to use this script :
#ruby pause.rb
#It automaticaly detecte if its a start or stop
#
require 'sqlite3'

class Pause

  def db
    @db ||= SQLite3::Database.new( "pause" )
  end

  ##:
  # Return 'true' if there is no data in temp table
  def last_entry_time
    @last_entry = db.execute( "select * from temp" )
    if @last_entry.empty?
      return nil
    else
      return Time.at(@last_entry.first.first)
    end
  end

  def start?
    return last_entry_time.nil?
  end

  def start_or_end_pause
    if start?
      start_pause
    else
      end_pause
    end
  end

  def start_pause
    start_time = Time.now
    puts 'Starting pause, at ' + start_time.to_s
    db.execute( "insert into temp values ( ? )", start_time.to_i )
  end

  def end_pause
    @end_time = Time.now
    puts 'Ending pause, at ' + @end_time.to_s
    puts "Duration : #{computed_time(last_entry_time, @end_time)}secondes (#{computed_time(last_entry_time, @end_time, :m)} minutes)"

    db.execute( "INSERT INTO pauses values (?, ?)", last_entry_time.to_i, computed_time(last_entry_time, @end_time) )
    db.execute( "DELETE from temp" )

    display_all_pause_of_this_day
  end

  def display_all_pause_of_this_day
    allday = db.execute("select day, duration from pauses where date(day, 'unixepoch') >= date('now') and date(day, 'unixepoch') <= date('now', '+1 day');")
    allday.each do |day|
      puts Time.at(day[0]).strftime("%Y/%m/%d") +
        " -> " +
        Time.at(day[1]).utc.strftime("%H:%M:%S")
    end

    sum = db.execute("select sum(duration) from pauses where date(day, 'unixepoch') >= date('now') and date(day, 'unixepoch') <= date('now', '+1 day');")
    puts "Durée total : " +
      Time.at(sum.first.first).utc.strftime("%H:%M:%S")
  end

  def computed_time(start_time, end_time, format = :s)
    case format
    when :s
      time = (end_time - start_time).round
    when :m
      time = ((end_time - start_time)/60).round(2)
    end
      time
  end

  def show

  end

end

pause = Pause.new
case ARGV[0]
when 'show'
  pause.display_all_pause_of_this_day
else
  pause.start_or_end_pause
end
