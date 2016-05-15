require "parse4plex/base_name_parser"
require 'net/http'
require 'json'

module Parse4Plex

  class FilmParser < BaseNameParser
    attr_reader :film

    def mime_type
      '📽 '
    end

    def canParse()
      withoutExtension = file[0,file.length-4]
      uri = URI('http://www.omdbapi.com')
      params = { :t => withoutExtension }
      uri.query = URI.encode_www_form(params)

      ui.debug "OMDB Query '#{uri.query}'"
      res = Net::HTTP.get_response(uri)
      ui.debug "API responded with '#{res.body}'"

      body = JSON.parse res.body
      ui.debug body.class
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

    def checkFilmWithUser(film)
      response = ui.prompt "Is this the right film? '#{film['Title']} (#{film['Year']})' (y/n)"
      if response == 'y' || response == 'yes'
        true
      else
        false
      end
    end

    def parseName()
      "#{@film['Title']} (#{@film['Year']}).#{file[-3, 3]}"
    end
  end
end
