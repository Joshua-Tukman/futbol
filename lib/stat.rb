require_relative 'dependents.rb'

class Stat
  include Calculable

  def self.from_csv(locations)
    Team.load_csv(locations[:teams])
    Game.load_csv(locations[:games])
    GameTeams.load_csv(locations[:game_teams])
    Season.create_seasons(Game.all, GameTeams.all)
  end

  attr_reader :games_data,
              :teams_data,
              :game_teams_data,
              :season_data

  def initialize(games_data, teams_data, game_teams_data, season_data)
    @games_data = games_data
    @teams_data = teams_data
    @game_teams_data = game_teams_data
    @season_data = season_data
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

  def average_goals_per_game
    average(@games_data.sum(&:total_score), @games_data.length).round(2)
  end

  def count_of_teams
    @teams_data.size
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
