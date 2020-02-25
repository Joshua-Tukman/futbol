module Calculable

  def average(numerator, denominator)
    numerator.to_f / denominator
  end

  def key_with_max_value(hash)
    hash.key(hash.values.max)
  end

  def key_with_min_value(hash)
    hash.key(hash.values.min)
  end

  def find_combined_data(team, data, field)
    post_season_data = data["Postseason"] ? post_season_data = data["Postseason"][field] : 0
    data["Regular Season"][field] + post_season_data
  end

  def find_team_name(team_id)
    Team.id_lookup[team_id]
  end

  def find_game_info(game_id)
    Game.game_lookup[game_id]
  end

end
