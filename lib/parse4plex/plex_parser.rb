require 'colorize'
require 'parse4plex/super_rugby_parser'
require 'parse4plex/film_parser'
require 'parse4plex/ui'

module Parse4Plex

  class PlexParser
    attr_accessor :ui

    def initialize(path, performParse=false)
      @ui = UI.new
      @path = path
      @nameParsers = [SuperRugbyParser, FilmParser]
      @supportedExtensions = 'mp4,avi'
      @performParse = performParse
    end

    def find_files(globQuery)
      Dir.glob(globQuery)
    end

    def parse
      filesParsed = []

      unless @path.nil?
        if @path[-1] != '/'
          @path = @path + '/'
        end
        globQuery = "#{@path}*.{#{@supportedExtensions}}"

        ui.info "Checking files..."

        queue = []

        find_files(globQuery).each do |fullFilePath|
          parsers = []

          ui.log "Finding parser for file '#{fullFilePath.blue}'"
          @nameParsers.each do |parserClass|
            parser = parserClass.new(fullFilePath, ui, @performParse)

            if parser.can_parse
              parsedName = parser.parse_name

              ui.log "#{parser.mime_type} - would parse from '#{parser.file}' to '#{parsedName.blue}'"
              parsers << parser
            end
          end

          if parsers.empty?
            ui.warn "No parsers found for '#{fullFilePath}'"
          else
            queue << {:file => fullFilePath, :parsers => parsers}
          end

        end

        if queue.empty?
          if @performParse
            ui.info "No files queued, all done here."
          else
            ui.info "#{'No files queued'.green} #{'(not that we were going to touch anything anyway)'.red}"
          end
        else
          if @performParse
            ui.info "Performing the following changes..."
          else
            ui.info "Here we would actually change the files if the #{'--parse'.blue} flag was used,"
            ui.info "instead we'll just print out what the changes would look like."
          end
          queue.each do |item|
            file = item[:file]
            if performParse file, item[:parsers]
              filesParsed << file
            end
          end

          ui.info "All done here."
        end
      else
        ui.err "Path must not be empty!"
      end

      filesParsed
    end

    def performParse(fullFilePath, parsers)
      unless parsers.length == 1
        ui.err "Multiple (#{parsers.length}) found for '#{fullFilePath.blue}'. Not quite sure what to do here..."
      else
        parser = parsers[0]
        parsedName = parser.parse_name
        ui.info "#{parser.mime_type} - '#{parsedName.blue}'"
        if @performParse
          parser.do_parse
        end
        true
      end
    end
  end

end
