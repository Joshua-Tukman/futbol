require './lib/data_loadable.rb'

class Team
  extend DataLoadable
  @@all_teams = nil

  def self.load_csv(file_path)
    @@all_teams = []
    create(file_path, @@all_teams)
  end

  def self.all
    @@all_teams
  end

  def self.names_by_id
    by_id = @@all_teams.group_by(&:team_id)
    by_id.each {|team_id, team_arr| by_id[team_id] = team_arr[0].teamname}
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
