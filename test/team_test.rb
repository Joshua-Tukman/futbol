require './test/test_helper'
require './lib/team'

class TeamTest < Minitest::Test

  def setup
    params = {
      team_id: "1",
      franchiseid: "23",
      teamname: "Atlanta United",
      abbreviation: "ATL",
      stadium: "Mercedes-Benz Stadium",
      link: "/api/v1/teams/1"
    }
    @team = Team.new(params)
    Team.load_csv('./data/teams_sample.csv')
    @new_team = Team.all[1]
  end

  def test_it_exists
    assert_instance_of Team, @team
  end

  def test_it_has_attributes
    assert_equal 1, @team.team_id
    assert_equal 23, @team.franchiseid
    assert_equal "Atlanta United", @team.teamname
    assert_equal "ATL", @team.abbreviation
    assert_equal "Mercedes-Benz Stadium", @team.stadium
    assert_equal "/api/v1/teams/1", @team.link
  end

  def test_it_can_create_teams_from_csv
    assert_instance_of Team, @new_team
    assert_equal 2, @new_team.team_id
    assert_equal 22, @new_team.franchiseid
    assert_equal "Seattle Sounders FC", @new_team.teamname
    assert_equal "SEA", @new_team.abbreviation
    assert_equal "Centruy Link Field", @new_team.stadium
    assert_equal "/api/v1/teams/2", @new_team.link
  end

  def test_it_contains_all_teams
    assert_instance_of Team, Team.all.sample
    assert_equal 2, Team.all.size
  end

end
