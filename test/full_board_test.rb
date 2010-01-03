require File.join(File.dirname(__FILE__), *%w[test_helper])
require 'boards/full_board'

class FullBoardTest < Test::Unit::TestCase
  def test_full_board_is_valid
    assert_nothing_raised(Exception) do
      ScotlandYard.new_game_with(FullBoard)
    end
  end
end
