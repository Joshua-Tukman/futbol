require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/teams'


class TeamTest < Minitest::Test

  def setup
  params = {
    team_id: "1",
    franchiseId: "23",
    teamName: "Atlanta United",
    abbreviation: "ATL",
    Stadium: "Mercedes-Benz Stadium",
    link: "/api/v1/teams/1"
  }

    @team = Team.new(params)
  end

  def test_it_exists
    assert_instance_of Team, @team
  end


end
