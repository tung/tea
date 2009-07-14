# Test if Spot can initialise.
# Expected result is nothing.

require 'spot'

puts <<TEST
This line should be the only output of this test.
TEST

Spot.init
