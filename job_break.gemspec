Gem::Specification.new do |s|
  s.name        = 'job_break'
  s.version     = '0.0.3'
  s.executables << 'job_break'

  s.date        = '2013-10-25'
  s.summary     = "Sort of chronometers"
  s.description = "Every time you start your break, type pause at the end, type pause again. Then the total will be displayed."

  s.authors     = ["Timothée Gauthier"]
  s.email       = 'itsumo.sibyllin@gmail.com'

  s.files       = [
    #"config.yml",
    "lib/job_break.rb",
    "lib/job_break/database.rb",
    "lib/job_break/display.rb",
    "lib/job_break/give_a_date.rb",
    "lib/job_break/pause.rb",
    "lib/job_break/pauses_controller.rb",
    "lib/job_break/locale/en.yml",
    "lib/job_break/locale/fr.yml",
  ]

  s.homepage    = 'https://github.com/Hettomei/job_break'
  s.license     = 'MIT'

  s.add_dependency 'sqlite3', '~> 1.3'
  s.add_dependency 'i18n', '~> 0.6'
  s.add_dependency 'adamantium', '~> 0.1'
end
