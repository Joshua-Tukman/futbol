require './test/test_helper'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test

  def setup
    game_path = './test/fixtures/games_sample.csv'
    team_path = './test/fixtures/teams_sample.csv'
    game_teams_path = './test/fixtures/game_teams_sample.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    @stat_tracker = StatTracker.from_csv(locations)
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_it_stores_a_collection_of_games
    assert_equal 471, @stat_tracker.games_data.size
    assert_instance_of Game, @stat_tracker.games_data.sample
    assert_instance_of Game, @stat_tracker.games_data.sample
  end

  def test_it_stores_a_collection_of_teams
    assert_equal 2, @stat_tracker.teams_data.size
    assert_instance_of Team, @stat_tracker.teams_data[0]
    assert_instance_of Team, @stat_tracker.teams_data[1]
  end

  def test_it_stores_a_collection_of_game_teams_data
    assert_equal 945, @stat_tracker.game_teams_data.size
    assert_instance_of GameTeams, @stat_tracker.game_teams_data.sample
    assert_instance_of GameTeams, @stat_tracker.game_teams_data.sample
  end

  def test_it_finds_highest_total_score
    assert_equal 9, @stat_tracker.highest_total_score
  end

  def test_it_finds_lowest_total_score
    assert_equal 0, @stat_tracker.lowest_total_score
  end

  def test_it_finds_biggest_blowout
    assert_equal 5, @stat_tracker.biggest_blowout
  end

  def test_it_finds_percentage_home_wins
    assert_equal 38.43, @stat_tracker.percentage_home_wins
  end

  def test_it_finds_percentage_visitor_wins
    assert_equal 39.49, @stat_tracker.percentage_visitor_wins
  end

  def test_it_finds_percentage_of_ties
    assert_equal 22.08, @stat_tracker.percentage_ties
  end

  def test_it_counts_games_by_season
    expected = {
      '20122013' => 51,
      '20132014' => 82,
      '20142015' => 85,
      '20152016' => 87,
      '20162017' => 82,
      '20172018' => 84
    }
    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

  def test_it_calculates_average_goals_per_game
    assert_equal 4.27, @stat_tracker.average_goals_per_game
  end

  def test_it_calculates_total_goals_per_season
    expected = {
      '20122013' => 218,
      '20132014' => 348,
      '20142015' => 343,
      '20152016' => 348,
      '20162017' => 357,
      '20172018' => 399
    }
    assert_equal expected, @stat_tracker.total_goals_per_season
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
    assert_equal expected, @stat_tracker.average_goals_by_season
  end

  def test_it_can_count_the_number_of_teams
    assert_equal 2, @stat_tracker.count_of_teams
  end

  def test_it_can_determine_the_winningest_team
    game_path = './test/fixtures/games_smaller_sample.csv'
    team_path = './test/fixtures/teams_sample.csv'
    game_teams_path = './test/fixtures/game_teams_smaller_sample.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)
    assert_equal "Seattle Sounders FC", stat_tracker.winningest_team
  end

  def test_it_can_determine_which_team_has_the_best_fans
    game_path = './test/fixtures/games_smaller_sample.csv'
    team_path = './test/fixtures/teams_sample.csv'
    game_teams_path = './test/fixtures/game_teams_smaller_sample.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)
    assert_equal "Atlanta United", stat_tracker.best_fans
  end

end
