require 'i18n'
require_relative './controllers/pauses_controller'

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

if ARGV.count == 0
  pause = PausesController.new
  pause.start_or_end_pause
else
  case ARGV[0]

  when 'show'
    pause = PausesController.new ARGV[1]
    pause.display_all_pauses
  when 'add'
    pause = PausesController.new
    pause.add_pause_minutes(ARGV[1].to_i)
    pause.display_all_pauses
  when '-h'
    display_help
  else
    puts "ArgumentError"
    display_help
  end
end
