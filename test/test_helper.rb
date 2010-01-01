require File.join(File.dirname(__FILE__), *%w[.. lib scotland_yard])
require 'test/unit'

class Test::Unit::TestCase
  def deny(first, *rest, &proc)
    assert(!first, *rest, &proc)
  end
end
