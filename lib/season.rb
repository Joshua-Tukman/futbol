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
              :game_teams_data

  def initialize(season_name, game_data, game_teams_data)
    @season_name = season_name
    @game_data = game_data
    @game_teams_data = game_teams_data
  end

end
