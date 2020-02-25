module Findable

  def find_combined_data(team, data, field)
    post_season_data = data["Postseason"] ? post_season_data = data["Postseason"][field] : 0
    data["Regular Season"][field] + post_season_data
  end

  def find_team_name(team_id)
    Team.all.find { |team| team.team_id == team_id}.teamname
  end

end
