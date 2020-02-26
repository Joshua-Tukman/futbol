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

  def count_of_games_by_season
    Game.count_of_games_by_season
  end

  def average_goals_per_game
    average(@games_data.sum(&:total_score), @games_data.length).round(2)
  end

  def total_goals_per_season
    Game.total_goals_per_season
  end

  def average_goals_by_season
    Game.average_goals_by_season
  end

  def count_of_teams
    @teams_data.size
  end

  def winningest_team
    find_team_name(GameTeams.winningest_team_id)
  end

  def home_win_percentage
    GameTeams.win_percentage_hoa("home")
  end

  def away_win_percentage
    GameTeams.win_percentage_hoa("away")
  end

  def best_fans
    find_team_name(GameTeams.best_fans_team_id)
  end

  def worst_fans
    GameTeams.better_away_records.map {|id| find_team_name(id)}
  end

  def goals_for_average(team_id, hoa = nil)
    GameTeams.goals_for_average(team_id, hoa)
  end

  def goals_against_average(team_id)
    Game.goals_against_average(team_id)
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

  def most_accurate_team(year)
    find_team_name(Season.most_accurate_team(year))
  end

  def least_accurate_team(year)
    find_team_name(Season.least_accurate_team(year))
  end

  def most_tackles(year)
    find_team_name(Season.most_tackles(year))
  end

  def fewest_tackles(year)
    find_team_name(Season.fewest_tackles(year))
  end

  def biggest_bust(year)
    find_team_name(Season.biggest_diff_id(year, 'bust'))
  end

  def biggest_surprise(year)
    find_team_name(Season.biggest_diff_id(year, 'surprise'))
  end

  def winningest_coach(year)
    Season.winningest_coach(year)
  end

  def worst_coach(year)
    Season.worst_coach(year)
  end

  def team_info(team_id)
    Team.team_info[team_id.to_s]
  end

end
