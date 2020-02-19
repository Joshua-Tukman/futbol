require 'csv'

class Game
  @@all_games = nil

  def self.load_csv(file_path)
    @@all_games = []
    CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
      teams_params = row.to_hash
      @@all_games << Game.new(teams_params)
    end
  end

  def self.all
    @@all_games
  end

  attr_reader :game_id,
              :season,
              :type,
              :date_time,
              :away_team_id,
              :home_team_id,
              :away_goals,
              :home_goals,
              :venue,
              :venue_link

  def initialize(params)
    @game_id = params[:game_id].to_i
    @season = params[:season].to_i
    @type = params[:type]
    @date_time = params[:date_time]
    @away_team_id = params[:away_team_id].to_i
    @home_team_id = params[:home_team_id].to_i
    @away_goals = params[:away_goals].to_i
    @home_goals = params[:home_goals].to_i
    @venue = params[:venue]
    @venue_link = params[:venue_link]
  end

end
