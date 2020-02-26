require_relative 'stat.rb'

class StatTracker < Stat

  def self.from_csv(locations)
    super
    StatTracker.new(Game.all, Team.all, GameTeams.all, Season.all)
  end

  def initialize(games_data, teams_data, game_teams_data, season_data)
    super
  end

end
