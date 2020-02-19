require './test/test_helper'
require './lib/game'

class GamesTest < Minitest::Test

  def setup
    params = {
      game_id: '2017030113',
      season: '20172018',
      type: 'Postseason',
      date_time: '4/16/18',
      away_team_id: '14',
      home_team_id: '1',
      away_goals: '2',
      home_goals: '3',
      venue: 'Mercedes-Benz',
      venue_link: '/api/v1/venues/null'
    }
    @game = Game.new(params)
    Game.load_csv('./test/fixtures/games_sample.csv')
    @new_game = Game.all[2]
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

  def test_it_has_attributes
    assert_equal 2017030113, @game.game_id
    assert_equal 20172018, @game.season
    assert_equal 'Postseason', @game.type
    assert_equal '4/16/18', @game.date_time
    assert_equal 14, @game.away_team_id
    assert_equal 1, @game.home_team_id
    assert_equal 2, @game.away_goals
    assert_equal 3, @game.home_goals
    assert_equal  'Mercedes-Benz', @game.venue
    assert_equal '/api/v1/venues/null', @game.venue_link
  end

  def test_it_can_create_games_from_csv
    assert_instance_of Game, @new_game
    assert_equal 2013020521, @new_game.game_id
    assert_equal 20132014, @new_game.season
    assert_equal 'Regular Season', @new_game.type
    assert_equal '12/19/13', @new_game.date_time
    assert_equal 9, @new_game.away_team_id
    assert_equal 1, @new_game.home_team_id
    assert_equal 2, @new_game.away_goals
    assert_equal 3, @new_game.home_goals
    assert_equal 'Mercedes-Benz Stadium', @new_game.venue
    assert_equal '/api/v1/venues/null', @new_game.venue_link
  end

  def test_it_contains_all_games
    assert_instance_of Game, Game.all.sample
    assert_equal 471, Game.all.size
  end

  def test_it_finds_total_score
    assert_equal 5, @new_game.total_score
  end

end
