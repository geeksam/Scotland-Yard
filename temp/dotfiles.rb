require File.join(File.dirname(__FILE__), *%w[.. lib scotland_yard])
require 'boards/full_board'
require 'boards/small_board'

ScotlandYard.dotfile_from_board FullBoard,  'full_board',  :label_nodes => true
ScotlandYard.dotfile_from_board SmallBoard, 'small_board', :label_nodes => true
