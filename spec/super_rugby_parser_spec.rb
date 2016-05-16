require 'spec_helper'

class SuperRugbyParserMock < Parse4Plex::SuperRugbyParser

  attr_reader :glob

  def initialize(fullFilePath, assets)
    @assets = assets
    ui = Parse4Plex::UI.new
    super fullFilePath, ui
  end

  def assets_exist?
    true
  end

  def list_files(globQuery)
    @glob = globQuery
    @assets
  end

end

describe Parse4Plex::SuperRugbyParser do
  it 'ignores special game' do
    file = "~/Rugby/RU.2015.Super.Rugby.SemiFinal.1.x264.mp4"
    parser = SuperRugbyParserMock.new(file, [])
    expect(parser.can_parse).not_to eq(true)
  end

  it 'ignores games already parsed' do
    file = "~/Rugby/Chiefs v Hurricanes - Super Rugby 2015 Round 18.mp4"
    parser = SuperRugbyParserMock.new(file, [])
    expect(parser.can_parse).not_to eq(true)
  end

  it 'correctly parses game file name' do
    file = "~/Rugby/RU.2015.Super.Rugby.R18.Chiefs.v.Hurricanes.x264.mp4"
    parser = SuperRugbyParserMock.new(file, [])
    expect(parser.can_parse).to eq(true)
    expectedName = "Chiefs v Hurricanes - Super Rugby 2015 Round 18.mp4"
    expect(parser.parse_name).to eq(expectedName)
  end

  it 'finds artwork for team' do
    file = "~/Rugby/RU.2015.Super.Rugby.R18.Chiefs.v.Hurricanes.x264.mp4"
    artwork = ['super_rugby_poster_chiefs.png', 'super_rugby_fanart_chiefs.png']
    parser = SuperRugbyParserMock.new(file, artwork)
    # Expect second team because assets for both teams are always parsed
    expectedName = ".plex_assets/super_rugby_*_hurricanes.*"
    parser.do_parse
    expect(parser.glob).to end_with(expectedName)
  end
end
