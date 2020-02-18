require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/game_teams'

class GameTeamsTest < Minitest::Test
  def setup
    params = {
      game_id: "2012030221",
      team_id: "3",
      HoA: "away",
      result: "LOSS",
      settled_in: "OT",
      head_coach: "John Tortorella",
      goals: 2,
      shots: 8,
      tackles: 44,
      pim: 8,
      powerPlayOpportunities: 3,
      powerPlayGoals: 0,
      faceOffWinPercentage: 44.8,
      giveaways: 17,
      takeaways: 7
    }

    @game_team = GameTeams.new(params)
  end

  def test_it_exists
    assert_instance_of GameTeams, @game_team
  end
end
