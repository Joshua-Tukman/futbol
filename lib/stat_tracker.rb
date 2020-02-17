require 'CSV'
# require './lib/game.rb'
# require './lib/team.rb'
# require './lib/game_teams.rb'

class StatTracker
  attr_reader :games_data,
              :teams_data,
              :game_teams_data

  def initialize(games_data, teams_data, game_teams_data)
    @games_data = games_data
    @teams_data = teams_data
    @game_teams_data = game_teams_data
  end

  def self.from_csv(stats_params)
    games_data = []
    CSV.foreach(stats_params[:games], headers: true, header_converters: :symbol) do |row|
      games_params = row.to_hash
      games_data << games_params
    end

    teams_data = []
    CSV.foreach(stats_params[:teams], headers: true, header_converters: :symbol) do |row|
      teams_params = row.to_hash
      teams_data << teams_params
    end

    game_teams_data = []
    CSV.foreach(stats_params[:game_teams], headers: true, header_converters: :symbol) do |row|
      game_teams_params = row.to_hash
      game_teams_data << game_teams_params
    end
    StatTracker.new(games_data, teams_data, game_teams_data)
  end

end
