


module Parse4Plex

  class UI
    attr_accessor :output
    attr_accessor :debug

    def initialize
      @output = true
      @debug = false
    end

    def prompt(msg)
      if output
        puts "#{msg}".blue
        gets
      end
    end

    def debug(msg)
      if (@output && @debug)
        puts "DEBUG: ".yellow + "#{msg}".blue
      end
    end

    def log(msg)
      if output
        puts "#{msg}"
      end
    end

    def info(msg)
      if output
        puts "#{msg}".green
      end
    end

    def warn(msg)
      if output
        puts "#{msg}".yellow
      end
    end

    def err(msg)
      if @output
        puts "#{msg}".red
      end
    end
  end

end
