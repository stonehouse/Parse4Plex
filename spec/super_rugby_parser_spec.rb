require 'spec_helper'

describe Parse4Plex::SuperRugbyParser do
  it 'ignores special game' do
    file = "RU.2015.Super.Rugby.SemiFinal.1.x264.mp4"
    ui = Parse4Plex::UI.new
    ui.output = false
    parser = Parse4Plex::SuperRugbyParser.new(file, ui)
    expect(parser.canParse).not_to eq(true)
  end

  it 'ignores games already parsed' do
    file = "Chiefs v Hurricanes - Super Rugby 2015 Round 18.mp4"
    ui = Parse4Plex::UI.new
    ui.output = false
    parser = Parse4Plex::SuperRugbyParser.new(file, ui)
    expect(parser.canParse).not_to eq(true)
  end

  it 'correctly parses game file name' do
    file = "RU.2015.Super.Rugby.R18.Chiefs.v.Hurricanes.x264.mp4"
    ui = Parse4Plex::UI.new
    ui.output = false
    parser = Parse4Plex::SuperRugbyParser.new(file, ui)
    expect(parser.canParse).to eq(true)
    expectedName = "Chiefs v Hurricanes - Super Rugby 2015 Round 18.mp4"
    expect(parser.parseName).to eq(expectedName)
  end
end
