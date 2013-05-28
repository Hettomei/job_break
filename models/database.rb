require 'sqlite3'
require_relative '../configu'

class Database

  def add_pause seconds
    db.execute("INSERT INTO pauses values (?, ?)", Time.now.to_i, seconds)
  end

  def all_pauses(date)
    date ||= 'now'
    db.execute("select day, duration from pauses where date(day, 'unixepoch') >= date('#{date}') and date(day, 'unixepoch') < date('#{date}', '+1 day');")
  end

  def sum_all_pauses(date)
    date ||= 'now'
    db.execute("select sum(duration) from pauses where date(day, 'unixepoch') >= date('#{date}') and date(day, 'unixepoch') < date('#{date}', '+1 day');")
  end

  def last_entry_temp
    db.execute( "select * from temp" )
  end

  def insert_time_temp time
    db.execute( "insert into temp values ( ? )", time.to_i )
  end

  def delete_temp_values
    db.execute( "DELETE from temp" )
  end

  private

  def db
    return @db if @db
    @db ||= SQLite3::Database.new(file)
    @db.execute_batch(sql_create_tables_if_not_exist)
    @db
  end

  def file
    #required when launch app with an alias
    @file ||= File.expand_path("../../dtb/dtb_pause_#{Configu.instance.environment}", __FILE__)
  end

  def sql_create_tables_if_not_exist
    "create table if not exists pauses(day datetime,  duration int);" +
      "create table if not exists temp(start_time datetime);"
  end

end
