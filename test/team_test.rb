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
    Team.load_csv('./test/fixtures/teams_sample.csv')
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

  def test_it_looks_up_team_name
    assert_equal "Atlanta United", Team.id_lookup[1]
    assert_equal "Seattle Sounders FC", Team.id_lookup[2]
  end

  def test_it_returns_team_info
    expected =
    {"1"=>
      {"abbreviation"=>"ATL",
        "franchise_id"=>"23",
        "link"=>"/api/v1/teams/1",
        "team_id"=>"1",
        "team_name"=>"Atlanta United"},
    "2"=>
      {"abbreviation"=>"SEA",
        "franchise_id"=>"22",
        "link"=>"/api/v1/teams/2",
        "team_id"=>"2",
        "team_name"=>"Seattle Sounders FC"}}
    assert_equal expected, Team.team_info
  end

  def test_it_can_group_team_names_by_id
    expected = {
      1 => "Atlanta United",
      2 => "Seattle Sounders FC"
    }
    assert_equal expected, Team.names_by_id
  end

end
