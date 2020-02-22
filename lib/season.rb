require_relative 'stat_tracker'

class Season

  @@all_seasons = []

  def self.all
    @@all_seasons
  end

  def self.create_seasons(game_data, game_teams_data)
    all_seasons = []
    season_game_data = []
    season_game_teams_data = []
    game_data.each do |game|
      all_seasons << game.season if !all_seasons.include?(game.season)
    end
    all_seasons.each do |season|
      game_data.each do |game|
        season_game_data << game if game.season == season
      end
      game_teams_data.each do |game_team|
        season_game_teams_data << game_team if season_game_data.include?(game_team.game_id)
      end
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
