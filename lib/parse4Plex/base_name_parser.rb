
module Parse4Plex
  
  class BaseNameParser

    def initialize(file)
      @file = file
    end

    def canParse()
      true
    end

    def parseName()
      "#{@file}"
    end
  end

end
