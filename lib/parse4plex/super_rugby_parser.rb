require "parse4plex/base_name_parser"

module Parse4Plex

  class SuperRugbyParser < BaseNameParser

    def initialize(fullFilePath, ui, performParse=false)
      super fullFilePath, ui, performParse
      @assetsPath = "#{ENV['HOME']}/.plex_assets"
    end

    def mime_type
      '🏉 '
    end

    def can_parse()
      if !file.include?(' ') &&
          file.start_with?('RU') &&
          file[20, 1] == 'R' &&
          file.include?('Super.Rugby') &&
          file.include?('.v.')

        return true
      end

      super
    end

    def parse_name()
      folder = File.dirname file
      name = File.basename file

      latterHalf = name[23, name.length].split(".")
      extension = latterHalf.last
      @team1 = latterHalf[1]
      @team2 = latterHalf[3]
      teams = "#{@team1} v #{@team2}"

      year = name[3, 4]
      round = name[21, 2].to_i

      "#{teams} - Super Rugby #{year} Round #{round}.#{extension}"
    end

    def do_parse()
      super
      check_artwork
    end

    def check_artwork()
      if assets_exist?
        team1Assets = find_team_assets(@team1)
        team2Assets = find_team_assets(@team2)

        if team1Assets.has_key?(:poster)
          ui.debug "Allocating poster for #{@team1}"
          allocate_asset team1Assets[:poster]
        elsif team2Assets.has_key?(:poster)
          ui.debug "Allocating poster for #{@team2}"
          allocate_asset team2Assets[:poster]
        end

        if team1Assets.has_key?(:fanart)
          ui.debug "Allocating fanart for #{@team1}"
          allocate_asset team1Assets[:fanart], 'fanart'
        elsif team2Assets.has_key?(:fanart)
          ui.debug "Allocating fanart for #{@team2}"
          allocate_asset team2Assets[:fanart], 'fanart'
        end
      else
        ui.debug "No plex assets found"
      end
    end

    def assets_exist?
      Dir.exists?(@assetsPath)
    end

    def find_team_assets(team)
      assets = {}
      list_files(@assetsPath + "/super_rugby_*_#{team.downcase}.*").each do |asset|
        unless ['.jpg', '.png', '.jpeg'].include? File.extname(asset)
          ui.warn "This extension is unlikely to work '#{asset}'"
        end
        if asset.include? 'poster'
          assets[:poster] = asset
        elsif asset.include? 'fanart'
          assets[:fanart] = asset
        end
      end
      assets
    end

    def list_files(path)
      Dir.glob(path)
    end

    def allocate_asset(asset, suffix=nil)
      assetName = File.basename(asset)
      assetExt = File.extname(assetName)
      parsedName = parse_name
      nameWithoutExt = File.basename(parsedName, File.extname(parsedName))
      if performParse
        FileUtils.cp asset, @dir
      else
        ui.debug "Would copy asset '#{asset}' to path '#{@dir}'"
      end

      unless suffix.nil?
        ext = "-#{suffix}#{assetExt}"
      else
        ext = "#{assetExt}"
      end

      if performParse
        File.rename("#{@dir}/#{assetName}", "#{@dir}/#{nameWithoutExt}#{ext}")
      else
        ui.debug "Would rename asset at '#{@dir}/#{assetName}' to '#{@dir}/#{nameWithoutExt}#{ext}'"
      end

    end
  end
end
