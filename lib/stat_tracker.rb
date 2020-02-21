require_relative 'dependents'

class StatTracker
  include Hashable
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
    @games_data.max_by(&:total_score).total_score
  end

  def lowest_total_score
    @games_data.min_by(&:total_score).total_score
  end

  def biggest_blowout
    @games_data.max_by(&:margin_of_victory).margin_of_victory
  end

  def percentage_home_wins
    average(Game.home_wins, @games_data.length).round(2)
  end

  def percentage_visitor_wins
    average(Game.visitor_wins, @games_data.length).round(2)
  end

  def percentage_ties
    average(Game.ties, @games_data.length).round(2)
  end

  def count_of_games_by_season
    Game.count_of_games_by_season
  end

  def average_goals_per_game
    total_goals = @games_data.sum(&:total_score)
    average(total_goals, @games_data.length).round(2)
  end

  def total_goals_per_season
  Game.total_goals_per_season
  end

  def average_goals_by_season
    # refactor with reduce?
    avg_goals = {}
    total_goals_per_season.each do |season, total_goals|
      avg_goals[season] = average(total_goals, count_of_games_by_season[season]).round(2)
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
    @teams_data.max_by {|team| goals_for_average(team.team_id)}.teamname
  end

  def worst_offense
    @teams_data.min_by {|team| goals_for_average(team.team_id)}.teamname
  end

  def best_defense
    @teams_data.min_by {|team| goals_against_average(team.team_id)}.teamname
  end

  def worst_defense
    @teams_data.max_by {|team| goals_against_average(team.team_id)}.teamname
  end

  def highest_scoring_visitor
    @teams_data.max_by {|team| goals_for_average(team.team_id, "away")}.teamname
  end

  def highest_scoring_home_team
    @teams_data.max_by {|team| goals_for_average(team.team_id, "home")}.teamname
  end

  def lowest_scoring_visitor
    @teams_data.min_by {|team| goals_for_average(team.team_id, "away")}.teamname
  end

  def lowest_scoring_home_team
    @teams_data.min_by {|team| goals_for_average(team.team_id, "home")}.teamname
  end

end
