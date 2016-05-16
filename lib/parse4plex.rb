require "parse4plex/plex_parser"

module Parse4Plex

  def Parse4Plex.parse(path, performParse=false, debug=false)
    parser = PlexParser.new(path, performParse)
    parser.ui.debug = debug
    parser.parse()
  end

end
