
module Parse4Plex

  class BaseNameParser

    attr_reader :file

    def initialize(file)
      @file = file
    end

    def canParse()
      false
    end

    def parseName()
      "#{@file}"
    end
  end

end
