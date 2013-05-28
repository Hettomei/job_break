require 'i18n'
require_relative './models/pause'

def load_i18n
  #required when launch app with an alias
  a = File.expand_path("../locale", __FILE__) #get 'locale' dir
  I18n.load_path = ["#{a}/en.yml", "#{a}/fr.yml"]
  I18n.locale = Configu.instance.locale
end

def display_help
  7.times do |n|
    puts I18n.t("pause.help.text0#{n+1}")
  end
end

load_i18n

case ARGV[0]

when 'show'
  pause = Pause.new ARGV[1]
  pause.display_all_pauses
when 'add'
  pause.add_pause_minutes(ARGV[1].to_i)
  pause.display_all_pauses
when '-h'
  display_help
else
  if ARGV.count == 0
    pause = Pause.new
    pause.start_or_end_pause
  else
    puts "ArgumentError"
    display_help
  end
end
