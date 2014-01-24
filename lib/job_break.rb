require 'i18n'

module JobBreak

  class Main
    def initialize
      locale = 'fr'
      #locale = 'en'
      I18n.enforce_available_locales = true
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
        PausesController.new.start_or_end_pause
      else
        case args[0]

        when 'show'
          PausesController.new(args[1]).display_all_pauses
        when 'showloop'
          PausesController.new(args[1]).show_loop
        when 'add'
          pause = PausesController.new
          pause.add_pause_minutes(args[1].to_i, args[2]) #args 2 is a comment
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
end

require 'job_break/pauses_controller'
require 'job_break/database'
require 'job_break/pause'
require 'job_break/give_a_date'
require 'job_break/display'
