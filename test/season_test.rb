require './test/test_helper'
require './lib/season.rb'
require './lib/stat_tracker'

class SeasonTest < Minitest::Test

  def setup
    game_path = './test/fixtures/games_smaller_sample.csv'
    team_path = './test/fixtures/teams_sample.csv'
    game_teams_path = './test/fixtures/game_teams_smaller_sample.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    @stat_tracker = StatTracker.from_csv(locations)
    @season = @stat_tracker.season_data[0]
  end

  def test_it_exists
    assert_instance_of Season, @season
  end

end
