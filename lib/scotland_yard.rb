$: << File.dirname(__FILE__)
require 'scotland_yard/game'

module ScotlandYard
  module_function
  def new_game_with(board_hash)
    Game.new(board_hash)
  end

  class AsymmetricNodesListException < Exception; end
  class AsymmetricEdgesListException < Exception; end

  def validate_board!(board_hash)
    board_hash.each do |this_node, this_edges_hash|
      this_edges_hash.each do |ticket, destinations|
        destinations.each do |that_node|
          # First, make sure the top-level hash knows about the destination
          that_edges_hash = board_hash[that_node]
          if that_edges_hash.nil?
            raise AsymmetricNodesListException, "#{this_node} refers to #{that_node}, but #{that_node} doesn't seem to exist!"
          end

          # If so, make sure you can get here from there
          that_nodes_destinations = (that_edges_hash[ticket] rescue []) || []
          if that_nodes_destinations.include?(this_node)
            next
          else
            raise AsymmetricEdgesListException, "#{this_node} says you can reach #{that_node}, but #{that_node} doesn't say you can reach #{this_node}!"
          end
        end
      end
    end
  end
end
