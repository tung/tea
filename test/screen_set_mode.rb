# Test if the screen can initialise.
# Expected results:
#
#  * output of "screen size is 320x240"
#  * a blank 320x240 display window for 2 seconds.

require 'sprout'

Sprout.init
Sprout.screen_mode 320, 240

puts "screen size is #{Sprout.screen.w}x#{Sprout.screen.h}"

sleep 2
