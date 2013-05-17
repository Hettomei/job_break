require 'i18n'
require_relative './models/pause'

a = File.expand_path("../locale", __FILE__) #required when launch app with an alias
I18n.load_path = ["#{a}/en.yml", "#{a}/fr.yml"]
I18n.locale = :fr

pause = Pause.new

case ARGV[0]

when 'show'
  pause.display_all_pause_of_this_day ARGV[1]
when 'add'
  pause.add_pause_minutes(ARGV[1].to_i)
  pause.display_all_pause_of_this_day
when '-h'
  pause.display_help
else
  if ARGV.count == 0
    pause.start_or_end_pause
  else
    puts "ArgumentError"
    pause.display_help
  end

end
