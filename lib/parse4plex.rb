require "parse4plex/plex_parser"

module Parse4Plex

  def Parse4Plex.parse(path, performParse=false)
    parser = PlexParser.new(path, performParse)
    parser.parse()
  end

end
