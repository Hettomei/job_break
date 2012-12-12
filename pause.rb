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
    dtb_file = File.join(File.dirname(File.expand_path(__FILE__)), 'z_pause')
    @db ||= SQLite3::Database.new( dtb_file )
  end

  def last_entry_time
    last_entry = db.execute( "select * from temp" )
    if last_entry.empty?
      return nil
    else
      return Time.at(last_entry.flatten.first)
    end
  end

  def started?
    return !!last_entry_time
  end

  def start_or_end_pause
    unless started?
      start_pause
    else
      end_pause
    end
  end

  def start_pause
    start_time = Time.now
    puts 'Début de la pause : ' + start_time.to_s
    db.execute( "insert into temp values ( ? )", start_time.to_i )
  end

  def end_pause
    @end_time = Time.now
    puts 'Fin de la pause : ' + @end_time.strftime("%H:%M:%S")
    puts "Durée : #{Time.at(@end_time - last_entry_time).utc.strftime("%H:%M:%S")}"

    add_pause(@end_time - last_entry_time)
    db.execute( "DELETE from temp" )

    display_all_pause_of_this_day
  end

  def display_all_pause_of_this_day
    allday = db.execute("select day, duration from pauses where date(day, 'unixepoch') >= date('now') and date(day, 'unixepoch') <= date('now', '+1 day');")
    allday.each do |day|
      str = Time.at(day[0]).strftime("%Y/%m/%d") +  " -> "
      if day[1] < 0
        str.concat('- ')
      else
        str.concat('  ')
      end
       str.concat(Time.at(day[1].abs).utc.strftime("%H:%M:%S"))
       puts str
    end
    sum = db.execute("select sum(duration) from pauses where date(day, 'unixepoch') >= date('now') and date(day, 'unixepoch') <= date('now', '+1 day');")
    unless sum.flatten.compact.empty?
      puts "Durée total : " + Time.at(sum.flatten.first).utc.strftime("%H:%M:%S")
    end
    if started?
      puts 'Une pause est en cours, début : ' + Time.at(last_entry_time).strftime("%H:%M:%S")
      puts "Durée : #{Time.at(Time.now - last_entry_time).utc.strftime("%H:%M:%S")}"
    end
  end

  def add_pause(seconds)
    db.execute( "INSERT INTO pauses values (?, ?)", Time.now.to_i, seconds )
  end

  def add_pause_minutes(minutes)
    add_pause(minutes*60)
  end
end

pause = Pause.new
case ARGV[0]
when 'show'
  pause.display_all_pause_of_this_day
when 'add'
  pause.add_pause_minutes(ARGV[1].to_i)
  pause.display_all_pause_of_this_day
else
  pause.start_or_end_pause
end
