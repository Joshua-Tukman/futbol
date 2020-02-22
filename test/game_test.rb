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
    assert_equal '2017030113', @game.game_id
    assert_equal '20172018', @game.season
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
    assert_equal '2013020521', @new_game.game_id
    assert_equal '20132014', @new_game.season
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

  def test_it_finds_margin_of_victory
    assert_equal 1, @new_game.margin_of_victory
  end

  def test_it_can_return_number_of_home_wins
    assert_equal 181, Game.home_wins
  end

  def test_it_can_return_number_of_visitor_wins
    assert_equal 186, Game.visitor_wins
  end

  def test_it_can_return_number_of_ties
    assert_equal 104, Game.ties
  end

  def test_it_can_return_count_of_games_by_season
    expected = {
      '20122013' => 51,
      '20132014' => 82,
      '20142015' => 85,
      '20152016' => 87,
      '20162017' => 82,
      '20172018' => 84
    }
    assert_equal expected, Game.count_of_games_by_season
  end

  def test_it_can_return_total_goals_per_season
    expected = {
      '20122013' => 218,
      '20132014' => 348,
      '20142015' => 343,
      '20152016' => 348,
      '20162017' => 357,
      '20172018' => 399
    }
    assert_equal expected, Game.total_goals_per_season
  end

  def test_it_calculates_goals_against_per_team
    assert_equal 2.0, Game.goals_against_average(1)
    assert_equal 2.25, Game.goals_against_average(2)
  end

  def test_it_calculates_average_goals_per_season
    expected = {
      '20122013' => 4.27,
      '20132014' => 4.24,
      '20142015' => 4.04,
      '20152016' => 4.0,
      '20162017' => 4.35,
      '20172018' => 4.75
    }
    assert_equal expected, Game.average_goals_by_season
  end

end
