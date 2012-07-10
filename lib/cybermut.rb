class String

  def ^(other)
    raise ArgumentError, "Can't bitwise-XOR a String with a non-String" \
      unless other.kind_of? String
    raise ArgumentError, "Can't bitwise-XOR strings of different length" \
      unless self.length == other.length
    my_bytes = self.bytes.to_a
    other_bytes = other.bytes.to_a
    result = (0..self.length-1).collect { |i| my_bytes[i] ^ other_bytes[i] }
    result.pack("C*")
  end
end

require 'rubygems'

require 'active_support'

require File.dirname(__FILE__) + '/confirmation'
require File.dirname(__FILE__) + '/helper'

