# Test if the screen can be flipped without problems.
# Expected result is a 320x240 graphical window shown for 2 seconds.

require 'spot'

puts <<TEST
You should see a 320x240 window appear for 2 seconds.
TEST

Spot.init
Spot.screen_mode 320, 240
Spot.screen.flip

sleep 2
