require './test/test_helper'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test

  def setup
    game_path = './data/games_sample.csv'
    team_path = './data/teams_sample.csv'
    game_teams_path = './data/game_teams_sample.csv'

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

end
