require_relative "super_rugby_parser"

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

        globQuery = "#{@path}*.{#{@supportedExtensions}}"

        unless @performParse
          print "(TRIAL RUN)"
        end
        puts "Renaming the following files..."
        Dir.glob(globQuery) do |fullFilePath|
          dir = File.dirname fullFilePath
          file = File.basename fullFilePath

          @nameParsers.each do |parserClass|
            parser = parserClass.new(file)

            if parser.canParse
              parsedName = parser.parseName
              if @performParse
                File.rename(fullFilePath, "#{dir}/#{parsedName}")
              end
              puts "from '#{file}' to '#{parsedName}'"
              break
            end
          end
        end
      else
        puts "Path must not be empty!"
      end
    end
  end

end
