# Test if Sprout can initialise.
# Expected result is nothing.

require 'sprout'

puts <<TEST
This line should be the only output of this test.
TEST

Sprout.init
