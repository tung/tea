# Test if the screen can initialise.
# Expected result is a blank 320x240 display window for 2 seconds.

require 'sprout'

Sprout.init
Sprout::Screen.set_mode 320, 240

sleep 2
