# Futbol Whiteboard
### Andy Reid

#### Iteration 1 - Setup & File I/0
- Need to define `from_csv` method on Stat Tracker pre-initialize
  - Method needs to be passed argument with hash of all 3 file paths
  - `from_csv` needs to instantiate Stat Tracker? Unclear on `from_csv` vs `::from_csv`
      - :: ~ . in this case.
  - Loading CSV needs to instantiate other classes.

- Classes Needed
  - Stat Tracker
    - Require CSV, all other classes/modules, return instance of ST
    - Store all data we need as instance vars... Requires argument of data being read in...
    - Takes one hash as arg

  - Game
  - Team
  - Season
  - Game/Teams join? Probably... And/Or Season/Team?


#### Iteration 2 - Game Stats
#####   - highest_total_score
    - Need helper method at games to sum score of each team in that game.
    - Enum through this at ST level.
#####  - lowest_total_score
    - Should be able to use same helper method from above
##### - biggest_blowout
    - Need helper method at Games to find diff in scores
##### - percentage_home_wins
    - Need helper method to return 1 for win, can enum through @ ST level and select out home team.
##### - percentage_visitor_wins
    - Use same helper as above..., diff enum at ST.
##### - percentage_ties
    - Helper method at Games to return 1 for ties game. Think is a different method than the wins one above, but maybe not?
##### - count_of_games_by_season
  - Hash populated by reduce method at ST Level?
##### - average_goals_per_game
  - ST-level method to iterate & sum both goal totals from game
##### - average_goals_by_season
  - Similar to above, but reduced into Hash.

#### Iteration 3 - League Stats
##### - count_of_teams
    - Sum @ ST level from teams
##### - best_offense
    - Method at team level & enum
##### - worst_offense
    - Same method as above, diff enum
##### - best_defense
    - Similar to offense, just summing goals against instead of for @ team level
##### - worst_defense
    - same method as above, diff enum
##### - highest_scoring_visitor
    - Variant of best offense above - either as a separate method or as an argument passed to single method.
##### - highest_scoring_home_team
    - Same as above
##### - lowest_scoring_visitor
    - Essentially same as above
##### - lowest_scoring_home_team
    - Essentially same as above
##### - winningest_team
    - Probably method at team & enum?
##### - best_fans
    - Maybe use winnginest team method with optional arg for home/away & then iterate?
##### - worst_fans
    - Iterate through above method? and pull out names.

#### Iteration 4 - Season Stats
##### - biggest_bust
  - Need to account for WP in each season
##### - biggest_surprise
  - Same as above
##### - winningest_coach
  - Do coaches change teams? Otherwise, can just pull from team with highest WP for season.
##### - worst_coach
  - Same as above.
##### - most_accurate_team
  - Enum through games? - Should be a more performant way.
##### - least_accurate_team
##### - most_tackles
  - Same as above on accuracy.
##### - fewest_tackles


#### Iteration 5 - Team Stats
##### - team_info
  - Hash on Team Class
##### - best_season
  - Enum through Season/Team
##### - worst_season
  - Same as above
##### - average_win_percentage
  - Enum from Game
##### - most_goals_scored
  - Enum from Game
##### - fewest_goals_scored
  - Same as above
##### - favorite_opponent
  -
##### - rival
  -
##### - biggest_team_blowout
##### - worst_loss
##### - head_to_head
##### - seasonal_summary
