require_relative 'game.rb'
require_relative 'team.rb'
require_relative 'game_teams.rb'
require_relative 'calculable'

class StatTracker
  include Calculable

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
    @games_data.max_by { |game| game.total_score}.total_score
  end

  def lowest_total_score
    @games_data.min_by { |game| game.total_score}.total_score
  end

  def biggest_blowout
    @games_data.max_by { |game| game.margin_of_victory }.margin_of_victory
  end

  def percentage_home_wins
    # Push home wins definition to game data class method & call here?
    home_wins = @games_data.select{ |game| game.home_goals > game.away_goals}.length
    (average(home_wins, @games_data.length) * 100).round(2)
  end

  def percentage_visitor_wins
    # Push visitor wins definition to game data class method & call here?
    visitor_wins =  @games_data.select{ |game| game.away_goals > game.home_goals}.length
    (average(visitor_wins, @games_data.length) * 100).round(2)
  end

  def percentage_ties
    # Push ties definition to game data class method & call here?
    ties = @games_data.select{ |game| game.margin_of_victory == 0}.length
    (average(ties, @games_data.length) * 100).round(2)
  end

  def count_of_games_by_season
    # Push all this logic to class method in Game & call that here?
    @games_data.reduce({}) do |games_count, game|
      if games_count[game.season.to_s].nil?
        games_count[game.season.to_s] = 1
      else
        games_count[game.season.to_s] += 1
      end
      games_count
    end
  end

  def average_goals_per_game

    total_goals = @games_data.sum { |game| game.total_score}
    average(total_goals, @games_data.length).round(2)
  end

  def total_goals_per_season
    # Push all this logic to class method in Game & call that here?
    @games_data.reduce({}) do |season_goals, game|

      if season_goals[game.season.to_s].nil?
        season_goals[game.season.to_s] = game.total_score
      else
        season_goals[game.season.to_s] += game.total_score
      end
      season_goals
    end
  end

  def average_goals_by_season
    # refactor with reduce?
    avg_goals = {}
    total_goals_per_season.each do |season, total_goals|
      avg_goals[season] = average(total_goals, count_of_games_by_season[season]).round(2)
    end
    avg_goals
  end

  def goals_for_average(team_id, filter = nil)
    goals = 0
    games = 0
    if filter.nil?
      @game_teams_data.each do |game|
        # push this logic to Games Teams class & call it here?
        goals += game.goals if game.team_id == team_id
        games += 1 if game.team_id == team_id
      end
    else
      @game_teams_data.each do |game|
        goals += game.goals if game.team_id == team_id && game.hoa == filter
        games += 1 if game.team_id == team_id && game.hoa == filter
      end
    end
    average(goals, games).round(2)
  end

  def goals_against_average(team_id)
    goals = 0
    games = 0
    @games_data.each do |game|
      # push this logic to Games class & call it here?
      if game.home_team_id == team_id
        goals += game.away_goals
        games += 1
      elsif game.away_team_id == team_id
        goals += game.home_goals
        games += 1
      end
    end
    average(goals, games).round(2)
  end

  def best_offense
    @teams_data.max_by do |team|
      goals_for_average(team.team_id)
    end.teamname
  end

  def worst_offense
    @teams_data.min_by do |team|
      goals_for_average(team.team_id)
    end.teamname
  end

  def best_defense
    @teams_data.min_by do |team|
      goals_against_average(team.team_id)
    end.teamname
  end

  def worst_defense
    @teams_data.max_by do |team|
      goals_against_average(team.team_id)
    end.teamname
  end

  def highest_scoring_visitor
    @teams_data.max_by do |team|
      goals_for_average(team.team_id, "away")
    end.teamname
  end

  def highest_scoring_home_team
    @teams_data.max_by do |team|
      goals_for_average(team.team_id, "home")
    end.teamname
  end

  def lowest_scoring_visitor
    @teams_data.min_by do |team|
      goals_for_average(team.team_id, "away")
    end.teamname
  end

  def lowest_scoring_home_team
    @teams_data.min_by do |team|
      goals_for_average(team.team_id, "home")
    end.teamname
  end

end
