require "colorize"

module Parse4Plex

  class PlexParser

    def initialize(path, performParse=false)
      @path = path
      @nameParsers = [SuperRugbyParser]
      @supportedExtensions = 'mp4,avi'
      @performParse = performParse
    end

    def parse()
      unless @path.nil?
        if @path[-1] != "/"
          @path = @path + "/"
        end
        globQuery = "#{@path}*.{#{@supportedExtensions}}"

        unless @performParse
          print "(TRIAL RUN)".red
        end
        puts "Renaming the following files...".green
        Dir.glob(globQuery) do |fullFilePath|
          dir = File.dirname fullFilePath
          file = File.basename fullFilePath

          parsed = false
          @nameParsers.each do |parserClass|
            parser = parserClass.new(file)

            if parser.canParse
              parsedName = parser.parseName
              if @performParse
                File.rename(fullFilePath, "#{dir}/#{parsedName}")
              end
              puts "Parsed from '#{file}' to '#{parsedName.blue}'"
              parsed = true
              break
            end
          end

          unless parsed
            puts "No parsers found".red + " for '#{file}'"
          end
        end
      else
        puts "Path must not be empty!"
      end
    end
  end

end
