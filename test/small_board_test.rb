require File.join(File.dirname(__FILE__), *%w[test_helper])
require 'boards/small_board'

class TestSmallBoard < Test::Unit::TestCase

  EdgesAsymmetric = {
    1 => { :yellow => [2] },
    2 => {},
  }
  NodesAsymmetric = {
    1 => { :yellow => [2] }
  }

  def setup
    @game = ScotlandYard.new_game_with(SmallBoard)
  end

  def test_instantiate_game_with_board
    assert_kind_of ScotlandYard::Game, @game
    assert_equal SmallBoard, @game.board
  end

  ##### Board validation #####
  def test_validate_board_passes_with_symmetric_board
    assert_nothing_raised(Exception) do
      ScotlandYard.validate_board!({
        1 => { :yellow => [2] },
        2 => { :yellow => [1] },
      })
    end
  end

  def test_validate_board_fails_with_asymmetric_node_list
    assert_raise(ScotlandYard::AsymmetricNodesListException) do
      deny ScotlandYard.validate_board!(NodesAsymmetric)
    end
  end

  def test_validate_board_fails_with_asymmetric_edge_list
    assert_raise(ScotlandYard::AsymmetricEdgesListException) do
      deny ScotlandYard.validate_board!(EdgesAsymmetric)
    end
  end

  def test_small_board_is_valid
    assert_nothing_raised(Exception) do
      ScotlandYard.validate_board!(SmallBoard)
    end
  end

  def test_game_validates_new_board
    assert_nothing_raised(Exception) do
      ScotlandYard.new_game_with(SmallBoard)
    end
    assert_raise(ScotlandYard::AsymmetricNodesListException) do
      ScotlandYard.new_game_with(NodesAsymmetric)
    end
    assert_raise(ScotlandYard::AsymmetricEdgesListException) do
      ScotlandYard.new_game_with(EdgesAsymmetric)
    end
  end

  ##### Test the known ticket types:  yellow, green, red. #####
  def test_zeroth_order_possibilities
    # If Mr. X was last seen at node 1 and hasn't moved, he could only be at node 1.
    expected = [1]
    actual   = @game.possible_locations(1, [])
    assert_equal(expected, actual)
  end

  def test_first_order_yellow_57
    # If Mr. X was last seen at node 57 and has used one yellow ticket, he could be at 43 or 58.
    expected = [43, 58].sort
    actual   = @game.possible_locations(57, [:yellow])
    assert_equal(expected, actual)
  end

  def test_first_order_yellow_43
    expected = [18, 31, 57].sort
    actual   = @game.possible_locations(43, [:yellow])
    assert_equal(expected, actual)
  end

  def test_first_order_green
    expected = [46, 58].sort
    actual   = @game.possible_locations(1, [:green])
    assert_equal(expected, actual)
  end

  def test_first_order_red
    expected = [46].flatten.compact.sort
    actual   = @game.possible_locations(1, [:red])
    assert_equal(expected, actual)
  end

  def test_second_order_yellow
    expected = [[18, 31, 57], [57, 44, 45]].flatten.compact.sort.uniq
    actual   = @game.possible_locations(57, [:yellow, :yellow])
    assert_equal(expected, actual)
  end

  def test_first_order_with_illegal_move
    expected = []
    actual   = @game.possible_locations(8, [:red])
    assert_equal(expected, actual)
  end

  def test_second_order_multimodal
    expected = [46]
    actual   = @game.possible_locations(8, [:yellow, :red])
    assert_equal(expected, actual)
  end

  ##### Test the special :black ticket type #####
  def test_first_order_black_57
    # If Mr. X was last seen at node 57 and has used one black ticket, he could be at 43 or 58.
    # (This is identical to test_first_order_yellow_57, and is used as a sanity check)
    expected = [43, 58].sort
    actual   = @game.possible_locations(57, [:black])
    assert_equal(expected, actual)
  end

  def test_first_order_black_1
    expected = [[8, 9], [46, 58]].flatten.compact.sort.uniq
    actual   = @game.possible_locations(1, [:black])
    assert_equal(expected, actual)
  end

  def test_second_order_yellow_black_57
    expected = [[18, 31, 57], [1, 44, 45, 46]].flatten.compact.sort.uniq
    actual   = @game.possible_locations(57, [:yellow, :black])
    assert_equal(expected, actual)
  end

end
