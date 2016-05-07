require_relative 'base_name_parser'

module Parse4Plex

  class PlexParser
    def initialize(path, performParse=false)
      @path = path
      @nameParsers = [BaseNameParser]
      @supportedExtensions = 'mp4,avi'
      @performParse = performParse
    end

    def parse()
      unless @path.nil?

        globQuery = "#{@path}*.{#{@supportedExtensions}}"
        Dir.glob(globQuery) do |file|
          @nameParsers.each do |parserClass|
            parser = parserClass.new(file)

            if parser.canParse
              parsedName = parser.parseName
              unless @performParse
                print "(Testrun)"
              else
                File.rename(file, parsedName)
              end
              puts "File parsed from '#{file}' to '#{parsedName}'"
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
