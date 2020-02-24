require './test/test_helper'
require './lib/season'
require './lib/stat_tracker'

class SeasonTest < Minitest::Test

  def setup
    game_path = './test/fixtures/games_sample.csv'
    team_path = './test/fixtures/teams_sample.csv'
    game_teams_path = './test/fixtures/game_teams_sample.csv'

    @locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    @stat_tracker = StatTracker.from_csv(@locations)
    @season = @stat_tracker.season_data[0]
  end

  def test_it_finds_unique_seasons
    expected = ["20172018", "20132014", "20122013", "20142015", "20162017", "20152016"]

    assert_equal expected, Season.find_all_seasons(@stat_tracker.games_data)
  end

  def test_it_finds_single_seasons
    expected = @stat_tracker.season_data[0]

    assert_equal expected, Season.find_single_season("20172018")
  end

  def test_it_finds_season_games
    game_path = './test/fixtures/games_smaller_sample.csv'
    team_path = './test/fixtures/teams_sample.csv'
    game_teams_path = './test/fixtures/game_teams_smaller_sample.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)
    season = stat_tracker.season_data[0]

    expected = [stat_tracker.games_data[3], stat_tracker.games_data[5]]

    assert_equal expected, Season.find_season_games(stat_tracker.games_data, "20122013")
  end

  def test_it_finds_season_game_ids
    game_path = './test/fixtures/games_smaller_sample.csv'
    team_path = './test/fixtures/teams_sample.csv'
    game_teams_path = './test/fixtures/game_teams_smaller_sample.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)
    season = stat_tracker.season_data[0]

    season_game_data = Season.find_season_games(stat_tracker.games_data, "20172018")
    expected = ["2017030113", "2017030114"]

    assert_equal expected, Season.find_season_game_ids(season_game_data)
  end

  def test_it_finds_season_game_teams
    game_path = './test/fixtures/games_smaller_sample.csv'
    team_path = './test/fixtures/teams_sample.csv'
    game_teams_path = './test/fixtures/game_teams_smaller_sample.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)
    season = stat_tracker.season_data[0]

    season_game_data = Season.find_season_games(stat_tracker.games_data, "20172018")
    expected = [stat_tracker.game_teams_data[6], stat_tracker.game_teams_data[7]]

    assert_equal expected, Season.find_season_game_teams(stat_tracker.game_teams_data, season_game_data)
  end

  def test_it_exists
    assert_instance_of Season, @season
  end

  def test_it_has_attributes
    game_path = './test/fixtures/games_smaller_sample.csv'
    team_path = './test/fixtures/teams_sample.csv'
    game_teams_path = './test/fixtures/game_teams_smaller_sample.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)
    season = stat_tracker.season_data[0]

    expected_game_data = Season.find_season_games(stat_tracker.games_data, "20172018")
    expected_game_team_data = Season.find_season_game_teams(stat_tracker.game_teams_data, expected_game_data)

    assert_equal "20172018", season.season_name
    assert_equal expected_game_data[0].game_id, season.game_data[0].game_id
    assert_equal expected_game_team_data[0].game_id, season.game_teams_data[0].game_id
    assert_equal expected_game_data.size, season.game_data.size
    assert_equal expected_game_team_data.size, season.game_teams_data.size
  end

  def test_it_finds_game_parent
    expected = @stat_tracker.games_data[0]

    assert_equal expected.game_id, @season.find_game_parent(2017030113).game_id
  end

  def test_it_creates_season_data_report
    expected =  {2=>{"Regular Season"=>{:wins=>15, :games=>43, :tackles=>900, :shots=>331, :goals=>103, :win_percentage=>0.3488372093023256, :shot_accuracy=>3.2136}}, 1=>{"Postseason"=>{:wins=>1, :games=>2, :tackles=>58, :shots=>17, :goals=>4, :win_percentage=>0.5, :shot_accuracy=>4.25}, "Regular Season"=>{:wins=>17, :games=>43, :tackles=>953, :shots=>334, :goals=>94, :win_percentage=>0.3953488372093023, :shot_accuracy=>3.5532}}}

    assert_equal expected, @season.season_data_report
  end

  def test_it_finds_most_accurate_team
    assert_equal "Seattle Sounders FC", Season.most_accurate_team("20172018")
  end

  def test_it_finds_least_accurate_team
    assert_equal "Atlanta United", Season.least_accurate_team("20172018")
  end

  def test_it_finds_team_with_most_tackles
    assert_equal "Atlanta United", Season.most_tackles("20172018")
  end

  def test_it_finds_team_with_least_tackles
    assert_equal "Seattle Sounders FC", Season.fewest_tackles("20172018")
  end

  def test_it_finds_team_id_with_biggest_bust
    game_path = './test/fixtures/fixtures_smaller/season_games.csv'
    team_path = './test/fixtures/teams_sample.csv'
    game_teams_path = './test/fixtures/fixtures_smaller/season_game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)
    assert_equal 2, Season.biggest_bust_id("20152016")
  end

end
