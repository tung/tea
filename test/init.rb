# Test if Tea can initialise.
# Expected result is nothing.

require 'tea'

puts <<TEST
This line should be the only output of this test.
TEST

Tea.init
