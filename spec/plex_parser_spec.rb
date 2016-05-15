require 'spec_helper'

class PlexParserMock < Parse4Plex::PlexParser

  attr_reader :glob

  def initialize(files)
    @files = files
    super '~/Downloads', false
    ui.output = false
  end

  def find_files(globQuery)
    @glob = globQuery
    @files
  end

end

describe Parse4Plex::PlexParser do

  it 'handles an empty path' do
    mock = PlexParserMock.new([])
    expect(mock.parse.length).to eq(0)
  end

  it 'ignores non-video files' do
    mock = PlexParserMock.new(['A file that is not a video file.txt'])
    mock.parse
    expect(mock.glob).to end_with '.{mp4,avi}'
  end

  it 'identifies super rugby parser' do
    files = ['~/Downloads/RU.2015.Super.Rugby.R18.Chiefs.v.Hurricanes.x264.mp4']
    mock = PlexParserMock.new(files)
    result = mock.parse
    expect(result.length).to eq(1)
  end

end
