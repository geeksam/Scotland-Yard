module ScotlandYard
  class Game
    attr_reader :board
    def initialize(board_hash)
      ScotlandYard.validate_board!(board_hash)  # may raise exception
      @board = board_hash
    end

    def possible_locations(last_known_location, *tickets_list)
      tickets_list = [tickets_list].flatten.compact
      locs = [last_known_location] # Start with this
      until tickets_list.empty?
        ticket = tickets_list.shift
        case ticket
        when :black
          locs = locs.map { |loc| board[loc].values.flatten }.flatten
        else
          locs = locs.map { |loc| board[loc][ticket] } .flatten
        end
      end
      locs.compact.sort.uniq
    end
  end
end