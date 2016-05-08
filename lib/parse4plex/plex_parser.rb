require "colorize"
require "parse4plex/super_rugby_parser"

module Parse4Plex

  class PlexParser

    def initialize(path, performParse=false)
      @path = path
      @nameParsers = [SuperRugbyParser]
      @supportedExtensions = 'mp4,avi'
      @performParse = performParse
    end

    def find_files(globQuery)
      Dir.glob(globQuery)
    end

    def parse
      filesParsed = []

      unless @path.nil?
        if @path[-1] != "/"
          @path = @path + "/"
        end
        globQuery = "#{@path}*.{#{@supportedExtensions}}"

        puts "Checking files...".green

        queue = []

        find_files(globQuery).each do |fullFilePath|
          parsers = []

          puts "Findings parser for file '#{fullFilePath.blue}'"
          @nameParsers.each do |parserClass|
            parser = parserClass.new(fullFilePath)

            if parser.canParse
              parsedName = parser.parseName

              puts "#{parser.mime_type} - would parse from '#{parser.file}' to '#{parsedName.blue}'"
              parsers << parser
            end
          end

          if parsers.empty?
            puts "No parsers found".red + " for '#{fullFilePath}'"
          else
            queue << {:file => fullFilePath, :parsers => parsers}
          end

        end

        if queue.empty?
          puts "No files queued, all done here.".green
        else
          if @performParse
            puts "Performing the following changes...".green
          else
            puts "Here we would actually change the files if the #{'--parse'.blue} flag was used,".green
            puts "instead we'll just print out what the changes would look like.".green
          end
          queue.each do |item|
            fullFilePath = item[:fullFilePath]
            if performParse fullFilePath, item[:parsers]
              filesParsed << fullFilePath
            end
          end

          puts "All done here.".green
        end
      else
        puts "Path must not be empty!"
      end

      filesParsed
    end

    def performParse(fullFilePath, parsers)
      unless parsers.length == 1
        puts "Multiple (#{parsers.length}) found for '#{fullFilePath.blue}'. Not quite sure what to do here..."
      else
        parser = parsers[0]
        parsedName = parser.parseName
        puts "#{parser.mime_type} - '#{parsedName.blue}'"
        if @performParse
          File.rename(fullFilePath, parser.dir + '/' + parsedName)
        end
        true
      end
    end
  end

end
