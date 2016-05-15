require 'spec_helper'

class FilmParserMock < Parse4Plex::FilmParser
  def initialize(file)
    ui = Parse4Plex::UI.new
    super file, ui
  end

  def checkFilmWithUser(film)
    true
  end
end

describe Parse4Plex::FilmParser do
  it 'finds film with omdbapi' do
    file = "Frozen.mp4"

    parser = FilmParserMock.new(file)
    expect(parser.canParse).to eq(true)

    expect(parser.parseName).to eq('Frozen (2013).mp4')
  end

  it 'finds film with ambiguous name' do
    file = "Total garbage, not really a film at all.mp4"
    parser = FilmParserMock.new(file)
    expect(parser.canParse).not_to eq(true)
  end
end
