require_relative 'pause'

pause = Pause.new

case ARGV[0]

when 'show'
  pause.display_all_pause_of_this_day
when 'add'
  pause.add_pause_minutes(ARGV[1].to_i)
  pause.display_all_pause_of_this_day
when '-h'
  pause.display_help
when '-d'
  pause.display_all_pause_of_this_day ARGV[1]
when '--date'
  pause.display_all_pause_of_this_day ARGV[1]
else
  if ARGV.count == 0
    pause.start_or_end_pause
  else
    puts "ArgumentError"
    pause.display_help
  end

end
