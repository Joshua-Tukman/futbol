require_relative 'stat.rb'

class StatTracker < Stat

  def self.from_csv(locations)
    super
    StatTracker.new(Game.all, Team.all, GameTeams.all, Season.all)
  end

  def initialize(games_data, teams_data, game_teams_data, season_data)
    super
  end

  def count_of_games_by_season
    Game.count_of_games_by_season
  end

  def total_goals_per_season
    Game.total_goals_per_season
  end

  def average_goals_by_season
    Game.average_goals_by_season
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
