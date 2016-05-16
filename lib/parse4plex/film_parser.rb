require "parse4plex/base_name_parser"
require 'net/http'
require 'json'

module Parse4Plex

  class FilmParser < BaseNameParser
    attr_reader :film

    def mime_type
      '📽 '
    end

    def can_parse()
      unless dir.include? 'Movies'
        ui.debug "Skipping FilmParser because path does not include 'Movies'"
        return false
      end

      withoutExtension = file[0,file.length-4]
      uri = URI('http://www.omdbapi.com')
      params = { :t => withoutExtension }
      uri.query = URI.encode_www_form(params)

      ui.debug "OMDB Query '#{uri.query}'"
      res = execute_query(uri)
      ui.debug "API responded with '#{res}'"

      body = JSON.parse res

      if body['Response'] == 'True'
        ui.debug "OMDB responded with success"
        if checkFilmWithUser body
          @film = body
          return true
        end
      else
        ui.debug "OMDB couldn't find a film matching the name '#{withoutExtension}'"
      end

      super
    end

    def execute_query(uri)
      Net::HTTP.get_response(uri).body
    end

    def checkFilmWithUser(film)
      response = ui.prompt "Is this the right film? '#{film['Title']} (#{film['Year']})' (y/n)"
      if response == 'y' || response == 'yes'
        true
      else
        false
      end
    end

    def parse_name()
      "#{@film['Title']} (#{@film['Year']}).#{file[-3, 3]}"
    end
  end
end
