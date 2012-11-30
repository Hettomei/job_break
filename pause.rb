##
#How to create sqlite3 table :
#
#$: gem install sqlite3
#$: sqlite3 pause ##pause is the database name
#> create table days(day datetime, id int);
#> create table pauses(id_day int,  duration_sec int);
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

  def temp
    db.execute( "select * from temp" )
  end
  ##
  # Return 'true' if there is no data in temp table
  def start?
    return temp.empty?
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
    end_time = Time.now
    puts 'Ending pause, at ' + end_time.to_s
    p temp.first.first
    puts "Duration : #{end_time - Time.at(temp.first.first)} secondes (#{(end_time - Time.at(temp.first.first))/60} minutes)"
  end

end

p = Pause.new

