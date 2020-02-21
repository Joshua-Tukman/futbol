require_relative 'game.rb'
require_relative 'team.rb'
require_relative 'game_teams.rb'
require_relative 'hashable.rb'

class StatTracker
  include Hashable

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

  def biggest_blowout
    Game.all.max_by { |game| game.margin_of_victory }.margin_of_victory
  end

  def percentage_home_wins
    num = Game.all.select{ |game| game.home_goals > game.away_goals}.length
    denom = Game.all.length
    (num.to_f / denom * 100).round(2)
  end

  def percentage_visitor_wins
    num = Game.all.select{ |game| game.away_goals > game.home_goals}.length
    denom = Game.all.length
    (num.to_f / denom * 100).round(2)
  end

  def percentage_ties
    num = Game.all.select{ |game| game.margin_of_victory == 0}.length
    denom = Game.all.length
    (num.to_f / denom * 100).round(2)
  end

  def count_of_games_by_season
    Game.all.reduce({}) do |games_count, game|
      if games_count[game.season.to_s].nil?
        games_count[game.season.to_s] = 1
      else
        games_count[game.season.to_s] += 1
      end
      games_count
    end
  end

  def average_goals_per_game
    num = Game.all.sum { |game| game.away_goals + game.home_goals}
    denom = Game.all.length
    (num.to_f / denom).round(2)
  end

  def total_goals_per_season
    Game.all.reduce({}) do |season_goals, game|
      if season_goals[game.season.to_s].nil?
        season_goals[game.season.to_s] = game.total_score
      else
        season_goals[game.season.to_s] += game.total_score
      end
      season_goals
    end
  end

  def average_goals_by_season
    avg_goals = {}
    total_goals_per_season.each do |key, value|
      avg_goals[key] = (value.to_f / count_of_games_by_season[key]).round(2)
    end
    avg_goals
  end

  def count_of_teams
    @teams_data.size
  end

  def winningest_team
    Team.names_by_id[GameTeams.winningest_team_id]
  end

  def home_win_percentage
    GameTeams.win_percentage_hoa("home")
  end

  def away_win_percentage
    GameTeams.win_percentage_hoa("away")
  end

  def best_fans
    home_win_percentage.each do |team, percent|
      home_win_percentage[team] = (percent - away_win_percentage[team])
    end
    best_fans_team_id = key_with_max_value(home_win_percentage)
    Team.names_by_id[best_fans_team_id]
  end

  def worst_fans
    away_better_record = away_win_percentage.select do |team_id, v|
      away_win_percentage[team_id] > home_win_percentage[team_id]
    end
    away_better_record.keys.map {|id| Team.names_by_id[id]}
  end

end
