require 'sqlite3'

class Database

  #ENVIRONNMENT = "dev"
  ENVIRONNMENT = "prod"

  def initialize
  end

  def db
    @db ||= SQLite3::Database.new(
      File.expand_path("../dtb_pause_#{ENVIRONNMENT}", __FILE__)
    )
  end
end
