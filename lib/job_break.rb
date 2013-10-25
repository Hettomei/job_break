require 'i18n'
require 'job_break/pauses_controller'

class JobBreak

  def initialize
    locale = 'fr'
    #locale = 'en'
    I18n.load_path = [File.expand_path("../job_break/locale", __FILE__) + "/#{locale}.yml"]
    I18n.locale = locale
  end

  def display_help
    5.times do |n|
      puts I18n.t("pause.help.text#{n+1}")
    end
  end

  def start args
    if args.count == 0
      pause = PausesController.new
      pause.start_or_end_pause
    else
      case args[0]

      when 'show'
        pause = PausesController.new args[1]
        pause.display_all_pauses
      when 'add'
        pause = PausesController.new
        pause.add_pause_minutes(args[1].to_i)
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
  end

end