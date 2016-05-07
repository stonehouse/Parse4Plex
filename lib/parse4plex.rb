require "parse4plex/base_name_parser"
require "parse4plex/super_rugby_parser"
require "parse4plex/plex_parser"

module Parse4Plex

  def Parse4Plex.parse(path, performParse=false)
    parser = PlexParser.new(path, performParse)
    parser.parse()
  end

end
