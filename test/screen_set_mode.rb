# Test if the screen can initialise.
# Expected results:
#
#  * output of "screen size is 320x240"
#  * a blank 320x240 display window for 2 seconds.

require 'spot'

puts <<TEST
You should see a 320x240 window for 2 seconds, and the text "screen size is 320x240"
TEST

Spot.init
Spot.screen_mode 320, 240

puts "screen size is #{Spot.screen.w}x#{Spot.screen.h}"

sleep 2
