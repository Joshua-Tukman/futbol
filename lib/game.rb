require_relative 'data_loadable.rb'
require_relative 'calculable.rb'

class Game
  extend DataLoadable
  extend Calculable

  @@all_games = nil

  def self.load_csv(file_path)
    @@all_games = []
    create(file_path, @@all_games)
  end

  def self.all
    @@all_games
  end

  def self.game_lookup
    @@game_lookup ||= @@all_games.reduce ({}) do |lookup, game|
      lookup[game.game_id] = {season: game.season, type: game.type}
      lookup
    end
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

  def self.average_goals_by_season
    avg_goals = {}
    self.total_goals_per_season.each do |season, total_goals|
      avg_goals[season] = average(total_goals, self.count_of_games_by_season[season]).round(2)
    end
    avg_goals
  end

  def self.goals_against_average(team_id)
    goals = 0
    games = 0
    @@all_games.each do |game|
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
