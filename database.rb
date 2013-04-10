require 'sqlite3'

class Database

  ENVIRONNMENT = "dev"
  #ENVIRONNMENT = "prod"

  def initialize
  end

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
    @db ||= SQLite3::Database.new(
      File.expand_path("../dtb_pause_#{ENVIRONNMENT}", __FILE__) #required when launch app with an alias
    )
  end

end
