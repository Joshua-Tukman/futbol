require_relative 'data_loadable'

class Game
  extend DataLoadable
  @@all_games = nil

  def self.load_csv(file_path)
    @@all_games = []
    create(file_path, @@all_games)
  end

  def self.all
    @@all_games
  end

  def self.home_wins
    @@all_games.select {|game| game.home_goals > game.away_goals}.length
  end

  def self.visitor_wins
    @@all_games.select {|game| game.home_goals < game.away_goals}.length
  end

  def self.ties
    @@all_games.select {|game| game.margin_of_victory.zero?}.length
  end

  def self.count_of_games_by_season
    games_by_season = @@all_games.group_by(&:season)
    games_by_season.each {|season, games| games_by_season[season] = games.size}
  end

  def self.total_goals_per_season
    games_by_total_goals = @@all_games.group_by(&:season)
    games_by_total_goals.each do |season, games|
      games_by_total_goals[season] = games.sum(&:total_score)
    end
  end

  attr_reader :game_id,
              :season,
              :type,
              :date_time,
              :away_team_id,
              :home_team_id,
              :away_goals,
              :home_goals,
              :venue,
              :venue_link

  def initialize(params)
    @game_id = params[:game_id]
    @season = params[:season]
    @type = params[:type]
    @date_time = params[:date_time]
    @away_team_id = params[:away_team_id].to_i
    @home_team_id = params[:home_team_id].to_i
    @away_goals = params[:away_goals].to_i
    @home_goals = params[:home_goals].to_i
    @venue = params[:venue]
    @venue_link = params[:venue_link]
  end

  def total_score
    @home_goals + @away_goals
  end

  def margin_of_victory
    (@home_goals - @away_goals).abs
  end

end
