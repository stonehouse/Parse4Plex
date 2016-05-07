require_relative 'base_name_parser'

module Parse4Plex

  class SuperRugbyParser < BaseNameParser

    def canParse()
      if file.include? '.Super.Rugby.'
        return true
      end

      super
    end

    def parseName()
      folder = File.dirname file
      name = File.basename file

      latterHalf = name[23, name.length].split(".")
      extension = latterHalf.last
      teams = "#{latterHalf[1]} v #{latterHalf[3]}"

      year = name[3, 4]
      round = name[21, 2].to_i

      "#{teams} - Super Rugby #{year} Round #{round}.#{extension}"
    end
  end
end
