
## Questions to Resolve
- Do we need a seasons class? Will building that remove some of the processing of the calc's below? I'm leaning towards yes.
- How much refactoring of existing code do we need to do before diving into Its 4/5?
- How do we split up work on these? Once we resolve the question around Season class, there's no reason we can't work on all of these simultaneously. Each iteration has a few that go together & will rely on common methods... but each group of methods is fairly independent from other groups of methods.


#### Iteration 4 - Season Stats
##### - biggest_bust
  - Need to account for WP in each season
  - Recommend helper method at Team class that queries Game data and sums WP by season
  - Helper method will require an argument indicating whether it's regular or post-season
  - Second method at Team will compare results of two calls to helper method & determine difference
  - Simple method at ST can call this 2nd method from team.
##### - biggest_surprise
  - Effectively same approach as above. Initial helper method can be reused.
  - May need different 2nd method (or maybe make it in a reusable way?)
  - Simple method at ST can call this.
##### - winningest_coach
  - Coach is stored at Game Team level along with win/loss status.
  - Season is stored at Games level.
  - I can think of a couple options
    1. Method at Games to create a nested hash of coach wins per season by querying associated game team data e.g:
      Hash = {
        :20122013 => {"Tyler" => 35,
                        "Josh" => 42,
                        "Ash" = 41,
                        "Andy" => 2},
        :20132014 => {blah, blah}
      }

    2. Create a season class populated on data load & house methods there to sum things up.

  - I'm not in love with either of those options, they're both inefficient... let's discuss.
##### - worst_coach
  - Same as above, just different method at ST to call data out of whatever we build.
##### - most_accurate_team
  - Game Teams data contains shots & goals - so we need to iterate through there to get the data for this calc.
  - Challenge is same as above with coaches - there's no season info in Game Teams. This may be an argument in favor of a Season class.
##### - least_accurate_team
##### - most_tackles
  - Effectively the same as most accurate team, we're just getting tackle data & summing instead of getting shots/goals. Maybe one method/module to pull all this info that can be used by other methods.
##### - fewest_tackles


#### Iteration 5 - Team Stats
##### - team_info
  - Hash on Team Class
##### - best_season
  - One way is to enum through teams & then for each enum through games.
  - Another approach would be the aforementioned season class & a hash there that holds Winning Percentage by team for each season.
##### - worst_season
  - Same as above
##### - average_win_percentage
  - Enum through game with Team argument
##### - most_goals_scored
  - Enum through Game Teams with Team argument
##### - fewest_goals_scored
  - Same as above
##### - favorite_opponent
  - This one's a bit tricky - I think we need to enum through games for a given team id, figure out if they were home/away, and then keep a running list of who they won/lost against. Ultimately that'll return a team id which we can use to pull name out of the teams table.
##### - rival
  - Effectively, same as above. Can use the same iteration through games.
##### - biggest_team_blowout
  - Iterate through games for a team ID & look at Margin Of Victory method we already built... just need to account for whether that team won or lost.
##### - worst_loss
##### - head_to_head
  - This is almost a helper method for the favorite opponent/rival methods above. Create this hash & then just return top/bottom values from it for those methods.
##### - seasonal_summary
  - Can't quite wrap my head around this today, but if we figure out all the other shit we can solve for this too. :)
