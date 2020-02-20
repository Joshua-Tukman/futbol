require_relative 'data_loadable'

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
