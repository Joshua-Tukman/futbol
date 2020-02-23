require_relative 'stat_tracker'

class Season

  @@all_seasons = []

  def self.all
    @@all_seasons
  end

  def self.find_all_seasons(game_data)
    game_data.map { |game| game.season }.uniq
  end

  def self.find_season_games(game_data, season)
    game_data.select { |game| game.season == season }
  end

  def self.find_season_game_ids(game_data)
    game_data.map { |game| game.game_id }
  end

  def self.find_season_game_teams(game_teams_data, season_game_data, season)
    game_teams_data.select { |game_team| self.find_season_game_ids(season_game_data).include?(game_team.game_id.to_s) }
  end

  def self.create_seasons(game_data, game_teams_data)
    all_seasons = self.find_all_seasons(game_data)
    all_seasons.each do |season|
      season_game_data = self.find_season_games(game_data, season)
      season_game_teams_data = self.find_season_game_teams(game_teams_data, season_game_data, season)
      @@all_seasons << new(season, season_game_data, season_game_teams_data)
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

  def find_game_parent(game_id)
    @game_data.find { |game| game.game_id == game_id.to_s}
  end

  def create_season_data_report
    season_report = {}
    @game_teams_data.each do |game_team|
      game = find_game_parent(game_team.game_id)
      teamid = game_team.team_id
      regpost = game.type
      outcome = game_team.result
      win = outcome == "WIN" ? 1 : 0
      tackle = game_team.tackles
      shot = game_team.shots
      goals = game_team.goals

      if season_report[teamid].nil?
        season_report[teamid] = {
                                  regpost => {
                                      wins: win,
                                      games: 1,
                                      tackles: tackle,
                                      shots: shot,
                                      goals: goals
                                    }
                                  }

      elsif season_report[teamid][regpost].nil?
         season_report[teamid][regpost] = {
                                            wins: win,
                                            games: 1,
                                            tackles: tackle,
                                            shots: shot,
                                            goals: goals
                                            }
      else
        season_report[teamid][regpost][:wins] += win
        season_report[teamid][regpost][:games] += 1
        season_report[teamid][regpost][:tackles] += tackle
        season_report[teamid][regpost][:shots] += shot
        season_report[teamid][regpost][:goals] += goals
      end
    end
    season_report
  end


end
