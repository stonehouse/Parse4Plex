
module Parse4Plex

  class BaseNameParser

    attr_reader :ui
    attr_reader :file
    attr_reader :dir

    def initialize(fullFilePath, ui)
      @ui = ui
      @dir = File.dirname fullFilePath
      @file = File.basename fullFilePath
    end

    def mime_type
      '📺 '
    end

    def canParse()
      false
    end

    def parseName()
      "#{@file}"
    end
  end

end
