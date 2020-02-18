class Team

  attr_reader   :team_id,
                :franchiseId,
                :teamName,
                :abbreviation,
                :stadium,
                :link

  def initialize(params)
    @team_id = params[:team_id]
    @franchiseId = params[:franchiseId]
    @teamName = params[:teamName]
    @abbreviation = params[:abbreviation]
    @stadium = params[:stadium]
    @link = params[:link]
  end

end
