require './test/test_helper'
require './lib/season.rb'
require './lib/stat_tracker'

class SeasonTest < Minitest::Test

  def setup
    @season = Season.new
  end

  def test_it_exists
    assert_instance_of Season, @season
  end

end
