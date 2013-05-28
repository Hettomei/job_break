require 'singleton'
require 'yaml'

class Configu
  include Singleton

  def locale
    file['locale'] || 'fr'
  end

  def environment
    file['environment'] || 'prod'
  end

  private

  def file
    @file ||= YAML::load_file(
      File.expand_path("../config.yml", __FILE__)
    )
  end
end
