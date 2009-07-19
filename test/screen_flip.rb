# Test if the screen can be flipped without problems.
# Expected result is a 320x240 graphical window shown for 2 seconds.

require 'tea'

puts <<TEST
You should see a 320x240 window appear for 2 seconds.
TEST

Tea.init
Tea::Screen.set_mode 320, 240
Tea::Screen.flip

sleep 2
