require_relative 'data_loadable'
require_relative 'calculable'
require_relative 'season'

class Team
  extend DataLoadable
  extend Calculable
  @@all_teams = nil

  def self.load_csv(file_path)
    @@all_teams = []
    create(file_path, @@all_teams)
  end

  def self.all
    @@all_teams
  end

  def self.id_lookup
    @@id_lookup = all.reduce ({}) do |lookup, team|
      lookup[team.team_id] = team.teamname
      lookup
    end
  end

  def self.team_info
    @@team_info ||= @@all_teams.reduce({}) do |lookup, team|
      lookup[team.team_id.to_s] = {
        "abbreviation" => team.abbreviation,
        "franchise_id" => team.franchiseid.to_s,
        "link" => team.link,
        "team_id" => team.team_id.to_s,
        "team_name" => team.teamname
      }
      lookup
    end
  end

  def self.names_by_id
    @@all_teams.reduce({}) do |by_id, team|
      by_id[team.team_id] = team.teamname
      by_id
    end
  end

  def self.best_season(team)
    # require "pry"; binding.pry
    team_seasons = Season.all.reduce({}) do |report, season|
      report[season.season_name] = {
        wins: season.season_data_report[team][:wins],
        games: season.season_data_report[team][:games]
      }
      report
    end
    team_seasons.max_by do |season|
      average(season[:wins], season[:games])
    end.season_name
  end

  attr_reader :team_id,
              :franchiseid,
              :teamname,
              :abbreviation,
              :stadium,
              :link

  def initialize(params)
    @team_id = params[:team_id].to_i
    @franchiseid = params[:franchiseid].to_i
    @teamname = params[:teamname]
    @abbreviation = params[:abbreviation]
    @stadium = params[:stadium]
    @link = params[:link]
  end

end
