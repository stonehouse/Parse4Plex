require 'spec_helper'
include Parse4Plex

describe Parse4Plex::SuperRugbyParser do
  it 'ignores special game' do
    file = "~/Rugby/RU.2015.Super.Rugby.SemiFinal.1.x264.mp4"
    allow(Dir).to receive(:exists?) {true}
    ui = UI.new
    ui.output = false
    parser = SuperRugbyParser.new(file, ui)
    expect(parser.can_parse).not_to eq(true)
  end

  it 'ignores games already parsed' do
    file = "~/Rugby/Chiefs v Hurricanes - Super Rugby 2015 Round 18.mp4"
    allow(Dir).to receive(:exists?) {true}
    ui = UI.new
    ui.output = false
    parser = SuperRugbyParser.new(file, ui)
    expect(parser.can_parse).not_to eq(true)
  end

  it 'correctly parses game file name' do
    file = "~/Rugby/RU.2015.Super.Rugby.R18.Chiefs.v.Hurricanes.x264.mp4"
    allow(Dir).to receive(:exists?) {true}
    ui = UI.new
    ui.output = false
    parser = SuperRugbyParser.new(file, ui)
    expect(parser.can_parse).to eq(true)
    expectedName = "Chiefs v Hurricanes - Super Rugby 2015 Round 18.mp4"
    expect(parser.parse_name).to eq(expectedName)
  end

  it 'finds artwork for team' do
    file = "~/Rugby/RU.2015.Super.Rugby.R18.Chiefs.v.Hurricanes.x264.mp4"
    artwork = ['super_rugby_poster_chiefs.png', 'super_rugby_fanart_chiefs.png']
    allow(Dir).to receive(:exists?) {true}
    # Expect second team because assets for both teams are always parsed
    hurricanesAssetGlob = ".plex_assets/super_rugby_*_hurricanes.*"
    allow(Dir).to receive(:glob).with(end_with(hurricanesAssetGlob)) {artwork}
    chiefsAssetGlob = ".plex_assets/super_rugby_*_chiefs.*"
    allow(Dir).to receive(:glob).with(end_with(chiefsAssetGlob)) {artwork}
    ui = UI.new
    ui.output = false
    parser = SuperRugbyParser.new(file, ui)
    parser.do_parse
  end

  it 'finds artwork for team but artwork has weird extension i.e. gif' do
    file = "~/Rugby/RU.2015.Super.Rugby.R18.Sunwolves.v.Jaguares.x264.mp4"
    fileWithWeirdExtension = 'super_rugby_fanart_sunwolves.gif'
    artwork = [fileWithWeirdExtension]
    allow(Dir).to receive(:exists?) {true}
    jaguaresAssetGlob = ".plex_assets/super_rugby_*_jaguares.*"
    allow(Dir).to receive(:glob).with(end_with(jaguaresAssetGlob)) {artwork}
    sunwolvesAssetGlob = ".plex_assets/super_rugby_*_sunwolves.*"
    allow(Dir).to receive(:glob).with(end_with(sunwolvesAssetGlob)) {artwork}

    allow(File).to receive(:rename).with('~/Rugby/RU.2015.Super.Rugby.R18.Sunwolves.v.Jaguares.x264.mp4', '~/Rugby/Sunwolves v Jaguares - Super Rugby 2015 Round 18.mp4')
    allow(FileUtils).to receive(:cp).with(fileWithWeirdExtension, '~/Rugby')
    allow(File).to receive(:rename).with('~/Rugby/super_rugby_fanart_sunwolves.gif', '~/Rugby/Sunwolves v Jaguares - Super Rugby 2015 Round 18-fanart.gif')
    ui = UI.new
    ui.output = false
    parser = SuperRugbyParser.new(file, ui, true)
    parser.do_parse
  end
end
