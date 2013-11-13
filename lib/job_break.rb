require 'i18n'

module JobBreak

  class Main
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
      require 'job_break/pauses_controller'
      if args.count == 0
        pause = PausesController.new
        pause.start_or_end_pause
      else
        case args[0]

        when 'show'
          pause = PausesController.new args[1]
          pause.display_all_pauses
        when 'showloop'
          showloop args[1]
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

    #TODO : add args -l instead of showloop, prefere show -l
    #TODO: add args to specify sleep duration
    #TODO, maybe use this instead of begin rescue :
    # http://www.ruby-doc.org/core-1.9.3/Kernel.html#method-i-trap
    def showloop date
      while true
        pause = PausesController.new date
        begin
          pause.display_all_pauses
          sleep 5
        rescue Interrupt
          puts "\nexiting..."
          exit
        end
      end
    end
  end
end

require 'job_break/database'
require 'job_break/pause'
require 'job_break/give_a_date'
require 'job_break/display'
