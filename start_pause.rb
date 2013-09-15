require 'i18n'
require_relative './controllers/pauses_controller'

def init
  #required when launch app with an alias
  local_path = File.expand_path("../locale", __FILE__)
  I18n.load_path = ["#{local_path}/en.yml", "#{local_path}/fr.yml"]
  I18n.locale = Configu.instance.locale
end

def display_help
  5.times do |n|
    puts I18n.t("pause.help.text#{n+1}")
  end
end

init

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
  when 'del'
    pause = PausesController.new
    pause.del_last
    pause.display_all_pauses
  when '-h'
    display_help
  else
    display_help
    raise ArgumentError
  end
end
