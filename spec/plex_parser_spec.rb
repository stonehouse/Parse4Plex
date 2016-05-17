require 'spec_helper'
include Parse4Plex

describe PlexParser do

  it 'handles an empty path' do
    mock = PlexParser.new('~/Downloads', false)
    allow(Dir).to receive(:glob) {[]}
    mock.ui.output = false
    expect(mock.parse.length).to eq(0)
  end

  it 'ignores non-video files' do
    path = '~/Documents'
    mock = PlexParser.new(path, false)
    mock.ui.output = false
    allow(Dir).to receive(:glob).with("#{path}/*.{mp4,avi}") {
      ['~/Documents/A file that is not a video file.txt']
    }
    mock.parse
  end

  it 'identifies super rugby parser' do
    path = '~/Downloads/Rugby'
    mock = PlexParser.new(path, false)
    mock.ui.output = false
    allow(Dir).to receive(:glob).with("#{path}/*.{mp4,avi}") {
      ['~/Downloads/Rugby/RU.2015.Super.Rugby.R18.Chiefs.v.Hurricanes.x264.mp4']
    }
    result = mock.parse
    expect(result.length).to eq(1)
  end

end
