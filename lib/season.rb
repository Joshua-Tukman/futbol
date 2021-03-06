require_relative 'calculable.rb'

class Season
  include Calculable
  extend Calculable

  @@all_seasons = nil

  def self.all
    @@all_seasons
  end

  def self.find_unique_seasons(game_data)
    game_data.map(&:season).uniq
  end

  def self.find_single_season(season_param)
    @@all_seasons.find {|season| season.season_name == season_param}
  end

  def self.find_season_games(game_data, season)
    game_data.select { |game| game.season == season }
  end

  def self.find_season_game_ids(game_data)
    game_data.map(&:game_id)
  end

  def self.find_season_game_teams(game_teams_data, season_game_data )
    game_teams_data.select do |game_team|
      self.find_season_game_ids(season_game_data).include?(game_team.game_id.to_s)
    end
  end

  def self.create_seasons(game_data, game_teams_data)
    @@all_seasons = []
    all_seasons = self.find_unique_seasons(game_data)
    all_seasons.each do |season|
      season_game_data = self.find_season_games(game_data, season)
      season_game_teams_data = self.find_season_game_teams(game_teams_data, season_game_data)
      @@all_seasons << new(season, season_game_data, season_game_teams_data)
    end
  end

  def self.season_report(season_param)
    self.find_single_season(season_param).season_data_report
  end

  def self.most_accurate_team(season_param)
    self.season_report(season_param).max_by do |team, data|
      average(find_combined_data(team, data, :goals), find_combined_data(team, data, :shots))
    end[0]
  end

  def self.least_accurate_team(season_param)
    self.season_report(season_param).min_by do |team, data|
      average(find_combined_data(team, data, :goals), find_combined_data(team, data, :shots))
    end[0]
  end

  def self.most_tackles(season_param)
    self.season_report(season_param).max_by do |team, data|
      find_combined_data(team, data, :tackles)
    end[0]
  end

  def self.fewest_tackles(season_param)
    self.season_report(season_param).min_by do |team, data|
      find_combined_data(team, data, :tackles)
    end[0]
  end

  def self.find_coach_wins(game_teams)
    game_teams.reduce({}) do |games_by_coach, game|
      win = game.result == "WIN" ? 1 : 0
      if games_by_coach[game.head_coach].nil?
        games_by_coach[game.head_coach] = {game: 1, win: win}
      else
        games_by_coach[game.head_coach][:game] += 1
        games_by_coach[game.head_coach][:win] += win
      end
      games_by_coach
    end
  end

  def self.winningest_coach(season_param)
    games = self.find_season_games(Game.all, season_param)
    game_teams = self.find_season_game_teams(GameTeams.all, games)
    find_coach_wins(game_teams).max_by do |coach, coachgames|
      average(coachgames[:win], coachgames[:game])
    end[0]
  end

  def self.worst_coach(season_param)
    games = self.find_season_games(Game.all, season_param)
    game_teams = self.find_season_game_teams(GameTeams.all, games)
    find_coach_wins(game_teams).min_by do |coach, coachgames|
      average(coachgames[:win], coachgames[:game])
    end[0]
  end

  def self.biggest_diff_id(season, bs)
    season_obj = self.find_single_season(season)
    bust = season_obj.win_percentage_diff_between_season_types
    if bs == 'bust'
      key_with_max_value(bust)
    elsif bs == 'surprise'
      key_with_min_value(bust)
    end
  end

  attr_reader :season_name,
              :game_data,
              :game_teams_data,
              :season_data_report

  def initialize(season_name, game_data, game_teams_data)
    @season_name = season_name
    @game_data = game_data
    @game_teams_data = game_teams_data
    @season_data_report ||= create_season_data_report
  end

  def win_percentage(season_type)
    reg = {}
    post = {}
    @season_data_report.each do |team, data|
      next if data["Postseason"].nil?
      reg[team] = average(data["Regular Season"][:wins], data["Regular Season"][:games])
      post[team] = average(data["Postseason"][:wins], data["Postseason"][:games])
    end
    return reg if season_type == "Regular Season"
    return post if season_type == "Postseason"
  end

  def win_percentage_diff_between_season_types
    reg = win_percentage("Regular Season")
    post = win_percentage("Postseason")
    diff = {}
    reg.each do |team, win_percent|
      diff[team] = win_percent - post[team]
    end
    diff
  end

  def win_count(outcome)
    outcome == "WIN" ? 1 : 0
  end

  def create_season_data_report
    season_report = {}
    @game_teams_data.each do |game_team|
      teamid = game_team.team_id
      regpost = find_game_info(game_team.game_id.to_s)[:type]
      outcome = game_team.result
      if season_report[teamid].nil?
        season_report[teamid] = {
          regpost => {
              wins: win_count(outcome),
              games: 1,
              tackles: game_team.tackles,
              shots: game_team.shots,
              goals: game_team.goals
            }
          }
      elsif season_report[teamid][regpost].nil?
         season_report[teamid][regpost] = {
            wins: win_count(outcome),
            games: 1,
            tackles: game_team.tackles,
            shots: game_team.shots,
            goals: game_team.goals
          }
      else
        season_report[teamid][regpost][:wins] += win_count(outcome)
        season_report[teamid][regpost][:games] += 1
        season_report[teamid][regpost][:tackles] += game_team.tackles
        season_report[teamid][regpost][:shots] += game_team.shots
        season_report[teamid][regpost][:goals] += game_team.goals
      end
    end
    season_report
  end

end
