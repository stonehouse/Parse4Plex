require 'spec_helper'

class FilmParserMock < Parse4Plex::FilmParser
  def initialize(file, serverResponse)
    ui = Parse4Plex::UI.new
    ui.output = false
    @serverResponse = serverResponse
    super file, ui
  end

  def checkFilmWithUser(film)
    true
  end

  def execute_query(uri)
    @serverResponse
  end
end

describe Parse4Plex::FilmParser do
  it 'finds film with omdbapi' do
    file = "Frozen.mp4"

    res = '{"Title":"Frozen","Year":"2013","Rated":"PG","Released":"27 Nov 2013","Runtime":"102 min","Genre":"Animation, Adventure, Comedy","Director":"Chris Buck, Jennifer Lee","Writer":"Jennifer Lee (screenplay), Hans Christian Andersen (story inspired by \"The Snow Queen\" by), Chris Buck (story by), Jennifer Lee (story by), Shane Morris (story by)","Actors":"Kristen Bell, Idina Menzel, Jonathan Groff, Josh Gad","Plot":"When the newly crowned Queen Elsa accidentally uses her power to turn things into ice to curse her home in infinite winter, her sister, Anna, teams up with a mountain man, his playful reindeer, and a snowman to change the weather condition.","Language":"English, Icelandic","Country":"USA","Awards":"Won 2 Oscars. Another 70 wins & 56 nominations.","Poster":"http://ia.media-imdb.com/images/M/MV5BMTQ1MjQwMTE5OF5BMl5BanBnXkFtZTgwNjk3MTcyMDE@._V1_SX300.jpg","Metascore":"74","imdbRating":"7.6","imdbVotes":"406,728","imdbID":"tt2294629","Type":"movie","Response":"True"}'
    parser = FilmParserMock.new(file, res)
    expect(parser.can_parse).to eq(true)

    expect(parser.parse_name).to eq('Frozen (2013).mp4')
  end

  it 'finds film with ambiguous name' do
    file = "Total garbage, not really a film at all.mp4"
    parser = FilmParserMock.new(file, '{"Response":"False","Error":"Movie not found!"}')
    expect(parser.can_parse).not_to eq(true)
  end
end
