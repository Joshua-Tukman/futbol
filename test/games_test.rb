require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/games'
require './lib/teams'


class GamesTest < Minitest::Test

  def setup
    params = {game_id: '2017030113', season: '20172018', type: 'Postseason', date_time: '4/16/18', away_team_id: '14', home_team_id: '1', away_goals: '2', home_goals: '3', venue: 'Mercedes-Benz', venue_link: '/api/v1/venues/null'}

    @game = Game.new(params)
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

  def test_it_has_attributes
    assert_equal '2017030113', @game.game_id
    assert_equal '20172018', @game.season
    assert_equal 'Postseason', @game.type
    assert_equal '4/16/18', @game.date_time
    assert_equal '14', @game.away_team_id
    assert_equal '1', @game.home_team_id
    assert_equal '2', @game.away_goals
    assert_equal '3', @game.home_goals
    assert_equal  'Mercedes-Benz', @game.venue
    assert_equal '/api/v1/venues/null', @game.venue_link
  end

end
