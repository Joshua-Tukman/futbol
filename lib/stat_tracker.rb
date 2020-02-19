require './lib/game.rb'
require './lib/team.rb'
require './lib/game_teams.rb'

class StatTracker

  def self.from_csv(locations)
    Team.load_csv(locations[:teams])
    Game.load_csv(locations[:games])
    GameTeams.load_csv(locations[:game_teams])
    StatTracker.new(Game.all, Team.all, GameTeams.all)
  end

  attr_reader :games_data,
              :teams_data,
              :game_teams_data

  def initialize(games_data, teams_data, game_teams_data)
    @games_data = games_data
    @teams_data = teams_data
    @game_teams_data = game_teams_data
  end

  def highest_total_score
    Game.all.max_by { |game| game.total_score}.total_score
  end

  def lowest_total_score
    Game.all.min_by { |game| game.total_score}.total_score
  end
end
