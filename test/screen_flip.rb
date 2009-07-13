# Test if the screen can be flipped without problems.
# Expected result is a 320x240 graphical window shown for 2 seconds.

require 'sprout'

puts <<TEST
You should see a 320x240 window appear for 2 seconds.
TEST

Sprout.init
Sprout.screen_mode 320, 240
Sprout.screen.flip

sleep 2
