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

  def initialize
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

end

p = Pause.new

