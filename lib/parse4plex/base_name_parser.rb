
module Parse4Plex

  class BaseNameParser

    attr_reader :ui
    attr_reader :file
    attr_reader :dir
    attr_reader :performParse

    def initialize(fullFilePath, ui, performParse=false)
      @ui = ui
      @fullFilePath = fullFilePath
      @dir = File.dirname fullFilePath
      @file = File.basename fullFilePath
      @performParse = performParse
    end

    def mime_type
      '📺 '
    end

    def can_parse()
      false
    end

    def parse_name()
      "#{@file}"
    end

    def do_parse()
      parsedName = parse_name
      fromPath = @dir + '/' + @file
      toPath = @dir + '/' + parsedName
      if @performParse
        File.rename(fromPath, toPath)
      else
        ui.debug "Would rename '#{fromPath}' to '#{toPath}'"
      end

    end
  end

end
