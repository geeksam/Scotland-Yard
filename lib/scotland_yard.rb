$: << File.dirname(__FILE__)
require 'scotland_yard/game'

module ScotlandYard
  module_function
  def new_game_with(board_hash)
    Game.new(board_hash)
  end

  class AsymmetricNodesListException < Exception; end
  class AsymmetricEdgesListException < Exception; end
  class SelfEdgeException < Exception; end

  def validate_board!(board_hash)
    board_hash.each do |this_node, this_edges_hash|
      this_edges_hash.each do |ticket, destinations|
        destinations.each do |that_node|
          # Make sure "there" isn't "here"
          if that_node == this_node
            raise SelfEdgeException, "#{this_node} has an edge to itself!"
          end

          # We can get "there" from "here", but does "there" exist?
          that_edges_hash = board_hash[that_node]
          if that_edges_hash.nil?
            raise AsymmetricNodesListException, "#{this_node} refers to #{that_node}, but #{that_node} doesn't seem to exist!"
          end

          # If so, make sure you can also get "here" from "there"
          that_nodes_destinations = (that_edges_hash[ticket] rescue []) || []
          if that_nodes_destinations.include?(this_node)
            next
          else
            raise AsymmetricEdgesListException, "#{this_node} says you can reach #{that_node} with a #{ticket} ticket, but #{that_node} doesn't say you can reach #{this_node}!"
          end
        end
      end
    end
  end

  def dotfile_from_board(board_hash, graph_name, options = {})
    filename = File.join(File.dirname(__FILE__), 'boards', graph_name + '.dot')
    label_width = board_hash.keys.map { |e| e.to_s.length }.max

    File.open(filename, 'w') do |file|
      # Open graph
      file << "graph scotland_yard {\n"

      # Write nodes
      file << "/***** NODES *****/\n"
      if options[:label_nodes]
        board_hash.to_a.each do |node, hash|
          code  = hash.map { |ticket, nodes| [ticket.to_s.upcase[/^./], nodes.length].join }.sort.join(' ').gsub(/B\d+/, '')
          label = "#{node} (#{code})"
          file << "\t%#{label_width}s [label=\"%s\"]\n" % [node, label]
        end
        file << "\n\n"
      end

      # Write edges
      file << "/***** EDGES *****/\n"
      board_hash.to_a.sort.each do |this_node, edge_hash|
        edge_hash.each do |color, nodes|
          nodes.sort.each do |that_node|
            next if this_node > that_node
            attributes = ["width=3", "color=#{color}"]
            attributes << "style=dotted" if color == :red
            file << "\t%#{label_width}s -- %#{label_width}s [%s]\n" % [this_node, that_node, attributes.join(', ')]
          end
        end
        file << "\n"
      end

      # Close graph
      file << "}\n"
    end
  end
end
