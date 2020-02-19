require 'csv'

class Team
  @@all_teams = nil

  def self.load_csv(file_path)
    @@all_teams = []
    CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
      teams_params = row.to_hash
      @@all_teams << Team.new(teams_params)
    end
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
    @team_id = params[:team_id]
    @franchiseid = params[:franchiseid]
    @teamname = params[:teamname]
    @abbreviation = params[:abbreviation]
    @stadium = params[:stadium]
    @link = params[:link]
  end

end
