require './lib/data_loadable.rb'

class GameTeams
  extend DataLoadable
  @@all_game_teams_data = nil

  def self.load_csv(file_path)
    @@all_game_teams_data = []
    create(file_path, @@all_game_teams_data)
  end

  def self.all
    @@all_game_teams_data
  end

  def self.win_percentage
    grouped = @@all_game_teams_data.group_by(&:team_id)
    grouped.map {|team, data| grouped[team] = data.map(&:result)}
    grouped.map do |team, data|
      grouped[team] = ((data.count("WIN")/data.size.to_f)*100).round(2)
    end
    grouped
  end

  attr_reader :game_id,
              :team_id,
              :hoa,
              :result,
              :settled_in,
              :head_coach,
              :goals,
              :shots,
              :tackles,
              :pim,
              :powerplayopportunities,
              :powerplaygoals,
              :faceoffwinpercentage,
              :giveaways,
              :takeaways

  def initialize(params)
    @game_id = params[:game_id].to_i
    @team_id = params[:team_id].to_i
    @hoa = params[:hoa]
    @result = params[:result]
    @settled_in = params[:settled_in]
    @head_coach = params[:head_coach]
    @goals = params[:goals].to_i
    @shots = params[:shots].to_i
    @tackles = params[:tackles].to_i
    @pim = params[:pim].to_i
    @powerplayopportunities = params[:powerplayopportunities].to_i
    @powerplaygoals = params[:powerplaygoals].to_i
    @faceoffwinpercentage = params[:faceoffwinpercentage].to_f
    @giveaways = params[:giveaways].to_i
    @takeaways = params[:takeaways].to_i
  end

end
